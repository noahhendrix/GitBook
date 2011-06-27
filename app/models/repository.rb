require 'activity_job'

class Repository < ActiveRecord::Base
  acts_as_commentable
  
  #associations
    has_many :commits, dependent: :destroy
    has_many :issues, dependent: :destroy
    has_many :pulls, dependent: :destroy
    has_many :notices, dependent: :destroy
    
    has_many :timeline_events, as: :subject, dependent: :destroy
  
  #attributes
    def slug
      [username, name].join('/')
    end
  
  #methods
    def sorted_timeline(page=0, per=15)
      timeline_events.page(page).per(per)
    end
  
  #callbacks
    before_create :update_with_repository_info
    after_create -> { Delayed::Job.enqueue(ActivityJob.new(self)) }
  
  #create methods
    def self.find_or_create(username, repo_name)
      find_by_slug(username, repo_name).first || create!(username: username, name: repo_name)
    end
  
  #constants
    ENQUE_NOTICE = 'We are fetching the history for this repository. Check back later.'
  
  #fetching from github
    def fetch_recent_activity
      fetch_recent_commits
      fetch_recent_issues
      fetch_recent_pulls
    end
    
    def self.fetch_all_repositories_for_user(username)
      Octokit.repos(username).map(&:name)
    end
  
  #scopes
    scope :find_by_slug, ->(username, name) {
      where('repositories.username LIKE ? and repositories.name LIKE ?', username, name)
    }
    scope :for_user, ->(username) { where('repositories.username = ?', username) }
  
  #validations
    validate :exists_on_github?
  
  private
    def exists_on_github?
      begin
        check_for_repository
      rescue Octokit::NotFound => e
        raise ActiveRecord::RecordNotFound
      end
    end
    
    def repository_info
      @repository_info ||= Octokit.repo(slug)
    end
    alias_method :check_for_repository, :repository_info
    
    def update_with_repository_info
      [:name, :description, :url].each do |attribute|
        send("#{attribute.to_s}=", repository_info[attribute])
      end
    end
    
    def fetch_recent_commits(limit=5)
      Octokit.commits(slug).take_while { |c| Commit.create_unless_found(self, c) }
    end
    
    def fetch_recent_issues(limit=5)
      Octokit.issues(slug).take_while { |i| Issue.create_unless_found(self, i) }
    end
    
    def fetch_recent_pulls(limit=5)
      Octokit.pulls(slug).take_while { |p| Pull.create_unless_found(self, p) }
    end
  
end
