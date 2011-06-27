class CreateRepositoryEvents < ActiveRecord::Migration
  def change
    create_table :repository_events do |t|
      t.string :type
      t.integer :repository_id
      t.string :username
      t.string :number
      t.string :title
      t.text :body
      t.string :url
      t.datetime :occurred_at

      t.timestamps
    end
    
    add_index :repository_events, :repository_id
    add_index :repository_events, [:type, :repository_id, :number]
  end
end