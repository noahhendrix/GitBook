require 'github_fetch'
require 'activity_job'

class Repository < ActiveRecord::Base
  acts_as_commentable
  
  #associations
    has_many :repository_events, dependent: :destroy
    has_many :notices, dependent: :destroy
    
    has_many :timeline_events, as: :subject, dependent: :destroy
  
  #attributes
    def slug
      [username, name].join('/')
    end
    
    alias_attribute :html_url, :url
  
  #methods
    def sorted_timeline(page=0, per=15)
      timeline_events.page(page).per(per)
    end
    
    def add_info_fetch_to_queue(opts = {})
      Delayed::Job.enqueue(ActivityJob.new(self), (opts[:priority] || 3))
    end
  
  #callbacks
    before_create :fetch_repository_info
    after_create :add_info_fetch_to_queue
  
  #create methods
    def self.find_or_create(username, repo_name)
      find_by_slug(username, repo_name).first || create!(username: username, name: repo_name)
    end
  
  #constants
    GITHUB_BASE_URL = 'https://github.com'
    ENQUE_NOTICE = 'We are fetching the history for this repository. Check back later.'
  
  #fetching from github
    def fetch_recent_activity
      fetch_repository_info && save
      fetch_recent_commits
      fetch_recent_issues
      fetch_recent_pulls
    end
    
    def self.fetch_all_repositories_for_user(username)
      GitHubFetch.all_for_user(username).map { |r| r['name'] }
    end
  
  #scopes
    scope :find_by_slug, ->(username, name) {
      where('repositories.username LIKE ? and repositories.name LIKE ?', username, name)
    }
  
  #validations
    validate :exists_on_github?
  
  private
    def fetch_from_github
      begin
        @fetch_from_github ||= GitHubFetch.new(slug, validate: true)
      rescue GitHubFetch::NotFound => e
        raise ActiveRecord::RecordNotFound
      end
    end
    alias_method :exists_on_github?, :fetch_from_github
    
    def fetch_repository_info
      ['name', 'description', 'html_url', 'homepage', 'language', 'forks',
       'open_issues', 'watchers'].each do |attribute|
        send("#{attribute.to_s}=", fetch_from_github.info[attribute])
      end
    end
    
    def fetch_recent_commits
      fetch_from_github.commits.take_while { |c| Commit.create_unless_found(self, c) }
    end
    
    def fetch_recent_issues
      fetch_from_github.issues.take_while { |i| Issue.create_unless_found(self, i) }
    end
    
    def fetch_recent_pulls
      fetch_from_github.pulls.take_while { |p| Pull.create_unless_found(self, p) }
    end
  
end
