class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :username
      t.integer :repository_id
      t.string :commit_id
      t.datetime :committed_at
      t.string :url
      t.text :message

      t.timestamps
    end
    
    add_index :commits, [:repository_id, :commit_id]
    add_index :commits, :repository_id
    add_index :commits, :username
  end
end