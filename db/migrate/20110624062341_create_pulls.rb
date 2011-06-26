class CreatePulls < ActiveRecord::Migration
  def change
    create_table :pulls do |t|
      t.string :title
      t.text :body
      t.string :url
      t.datetime :requested_at
      t.integer :number
      t.integer :username
      t.integer :repository_id

      t.timestamps
    end
    
    add_index :pulls, [:repository_id, :number]
    add_index :pulls, :repository_id
    add_index :pulls, :username
  end
end