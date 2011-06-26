class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :number
      t.string :title
      t.text :body
      t.string :state
      t.datetime :opened_at
      t.integer :repository_id
      t.string :username

      t.timestamps
    end
    
    add_index :issues, [:number, :repository_id]
    add_index :issues, :repository_id
    add_index :issues, :username
  end
end