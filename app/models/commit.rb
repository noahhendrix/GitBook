class Commit < ActiveRecord::Base
  acts_as_commentable
  
  #association
    belongs_to :user
    belongs_to :repository
    
    has_many :timeline_events, as: :secondary_subject, dependent: :destroy
  
  #attributes
    def url
      "#{Repository::GITHUB_BASE_URL}#{read_attribute(:url)}"
    end
  
  #callbacks
    fires :new_commit, on: :create,
                       actor: :user,
                       subject: :repository,
                       secondary_subject: :self,
                       occurred_at: :committed_at
  
  #class methods
    def self.create_unless_found(repo, commit_hash)
      return false if find_by_commit_id(commit_hash[:id])
      
      create(
        repository_id: repo.id,
        commit_id: commit_hash[:id],
        username: commit_hash[:author][:login],
        message: commit_hash[:message],
        committed_at: commit_hash[:committed_date],
        url: commit_hash[:url],
      )
    end
  
end
