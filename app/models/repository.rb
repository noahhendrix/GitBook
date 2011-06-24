class Repository < ActiveRecord::Base
  
  #associations
    belongs_to :user
    has_many :commits, dependent: :destroy
    has_many :issues, dependent: :destroy
    
    has_many :timeline_events, as: :secondary_subject, dependent: :destroy
  
  #attributes
    def username
      user.name
    end
    
    def slug
      [username, name].join('/')
    end
  
  #methods
    def sorted_timeline
      timeline_events.map(&:subject).sort_by!(&:timelined_at)
    end
  
  #class methods
    def self.find_by_username_and_name(username, name)
      joins(:user).where('users.name LIKE ? AND repositories.name LIKE ?', username, name).first
    end
    
    def self.create_by_username_and_name(username, name)
      user = User.find_or_create_by_name(username)
      repo = build_from_github("#{username}/#{name}")
      user.repositories << repo
      repo
    end
    
    def self.find_or_create(username, name)
      begin
        find_by_username_and_name(username, name) || create_by_username_and_name(username, name)
      rescue Octokit::NotFound => e
        raise ActiveRecord::RecordNotFound
      end
    end
  
  #fetching from github
    def fetch_recent_activity
      fetch_recent_commits
      fetch_recent_issues
      fetch_recent_pulls
    end
  
  private
    def self.build_from_github(slug)
      github_info = Octokit.repo(slug)
      new(name: github_info[:name], description: github_info[:description], url: github_info[:url])
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
