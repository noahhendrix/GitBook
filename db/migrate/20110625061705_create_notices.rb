class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.integer :repository_id
      t.string :message
    end
    
    add_index :notices, :repository_id
  end
end