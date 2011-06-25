class Notice < ActiveRecord::Base
  
  #associations
    has_many :timeline_events, as: :secondary_subject, dependent: :destroy
  
end
