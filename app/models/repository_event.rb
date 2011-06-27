class RepositoryEvent < ActiveRecord::Base
  acts_as_commentable
  
  #association
    belongs_to :repository
    has_many :timeline_events, as: :secondary_subject, dependent: :destroy
  
  #callbacks
    fires :repository_event, on: :create,
                             subject: :repository,
                             secondary_subject: :self,
                             occurred_at: :occurred_at

  #class methods
    def self.create_unless_found(repo, api_hash)
      mapped_attributes = map_api(api_hash).merge(repository_id: repo.id)
      return false if find_by_repository_id_and_number(repo.id, mapped_attributes[:number])
      create!(mapped_attributes)
    end
  
  
end
