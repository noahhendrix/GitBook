class Commit < ActiveRecord::Base
  
  #association
    belongs_to :user
    belongs_to :repository
    
    has_many :timeline_events, as: :subject, dependent: :destroy
  
  #attributes
    def github_url
      "https://github.com#{url}"
    end
    
    def timelined_at
      committed_on
    end
  
  #callbacks
    fires :new_commit, on: :create,
                       actor: :user,
                       secondary_subject: :repository,
                       occurred_at: :committed_on
  
  #class methods
    def self.create_unless_found(repo, commit_hash)
      return false if find_by_commit_id(commit_hash[:id])
      create(
        repository_id: repo.id,
        user_id: User.find_or_create_by_name(commit_hash[:committer][:login]).id,
        commit_id: commit_hash[:id],
        committed_on: commit_hash[:committed_date],
        url: commit_hash[:url],
        message: commit_hash[:message]
      )
    end
  
end
