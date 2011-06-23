class Repository < ActiveRecord::Base
  
  #associations
    belongs_to :user
  
  #attributes
    def slug
      [user.name, name].join('/')
    end
    alias_method :to_param, :slug
  
  #class methods
    def self.find_by_username_and_name(username, name)
      joins(:user).where('users.name = ? AND repositories.name = ?', username, name).first
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
  
  private
    def self.build_from_github(slug)
      github_info = Octokit.repo(slug)
      new(name: github_info[:name], description: github_info[:description], url: github_info[:url])
    end
  
end
