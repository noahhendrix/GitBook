class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.integer :user_id
      t.integer :repository_id
      t.string :commit_id
      t.datetime :committed_on
      t.string :url
      t.text :message

      t.timestamps
    end
    
    add_index :commits, :repository_id
  end
end