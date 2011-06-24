class Pull < ActiveRecord::Base
  
  #association
    belongs_to :user
    belongs_to :repository
  
  #attributes
   def timelined_at
     requested_at
   end
  
  #callbacks
    fires :new_pull, on: :create,
                     actor: :user,
                     secondary_subject: :repository,
                     occurred_at: :requested_at

  #class methods
    def self.create_unless_found(repo, pull_hash)
      return false if find_by_repository_id_and_number(repo.id, pull_hash[:number])
      create(
        number: pull_hash[:number],
        repository_id: repo.id,
        user_id: User.find_or_create_by_name(pull_hash[:user][:login]).id,
        title: pull_hash[:title],
        body: pull_hash[:body],
        requested_at: pull_hash[:created_at]
      )
    end
  
end
