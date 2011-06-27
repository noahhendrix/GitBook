class Issue < ActiveRecord::Base
  acts_as_commentable
  
  #association
    belongs_to :user
    belongs_to :repository
  
    has_many :timeline_events, as: :secondary_subject, dependent: :destroy
  
  #attributes
   def github_url
    "#{Repository::GITHUB_BASE_URL}/#{repository.slug}/issues/#{number}"
   end
  
  #callbacks
    fires :new_issue, on: :create,
                      actor: :user,
                      subject: :repository,
                      secondary_subject: :self,
                      occurred_at: :opened_at

  #class methods
    def self.create_unless_found(repo, issue_hash)
      issue = repo.issues.find_or_initialize_by_number(issue_hash[:number])
      return false if issue.persisted?
      
      issue.tap do |i|
        i.username = issue_hash[:user]
        i.title = issue_hash[:title]
        i.body = issue_hash[:body]
        i.state = issue_hash[:state]
        i.opened_at = issue_hash[:created_at]
      end.save
    end
end