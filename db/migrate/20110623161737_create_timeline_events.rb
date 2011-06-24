class CreateTimelineEvents < ActiveRecord::Migration
  
  def change
    create_table :timeline_events do |t|
      t.string   :event_type, :subject_type,  :actor_type,  :secondary_subject_type
      t.integer               :subject_id,    :actor_id,    :secondary_subject_id
      t.text                  :subject_data,  :actor_data,  :secondary_subject_data
      t.datetime :occurred_at
      t.timestamps
    end
  end
  
end