class Issue < ActiveRecord::Base
  acts_as_commentable
  
  #association
    belongs_to :user
    belongs_to :repository
  
    has_many :timeline_events, as: :subject, dependent: :destroy
  
  #attributes
   def timelined_at
     opened_at
   end
  
  #callbacks
    fires :new_issue, on: :create,
                      actor: :user,
                      secondary_subject: :repository,
                      occurred_at: :opened_at

  #class methods
    def self.create_unless_found(repo, issue_hash)
      return false if find_by_repository_id_and_number(repo.id, issue_hash[:number])
      create(
        number: issue_hash[:number],
        repository_id: repo.id,
        user_id: User.find_or_create_by_name(issue_hash[:user]).id,
        title: issue_hash[:title],
        body: issue_hash[:body],
        state: issue_hash[:state],
        opened_at: issue_hash[:created_at]
      )
    end
end