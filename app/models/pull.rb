class Pull < ActiveRecord::Base
  acts_as_commentable
  
  #association
    belongs_to :user
    belongs_to :repository
    
    has_many :timeline_events, as: :secondary_subject, dependent: :destroy
  
  #attributes
   def timelined_at
     requested_at
   end
  
  #callbacks
    fires :new_pull, on: :create,
                     actor: :user,
                     subject: :repository,
                     secondary_subject: :self,
                     occurred_at: :requested_at

  #class methods
    def self.create_unless_found(repo, pull_hash)
      return false if find_by_repository_id_and_number(repo.id, pull_hash[:number])
      
      create(
        repository_id: repo.id,
        number: pull_hash[:number],
        username: pull_hash[:user][:login],
        title: pull_hash[:title],
        body: pull_hash[:body],
        requested_at: pull_hash[:created_at]
      )
    end
  
end
