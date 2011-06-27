class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :username
      t.string :name
      t.text :description
      t.string :url

      t.timestamps
    end
    
    add_index :repositories, [:username, :name]
    add_index :repositories, :username
  end
end