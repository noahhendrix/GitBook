class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true

  default_scope :order => 'created_at ASC'

  # NOTE: Comments belong to a user
  belongs_to :user
  
  ########################################################
  
  fires :new_comment, on: :create,
                      actor: :user,
                      subject: :commentable,
                      secondary_subject: :self,
                      occurred_at: :now
  
  def now
    DateTime.now
  end
end
