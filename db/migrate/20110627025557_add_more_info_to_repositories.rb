class AddMoreInfoToRepositories < ActiveRecord::Migration
  def change
    
    add_column :repositories, :homepage, :string
    add_column :repositories, :language, :string
    add_column :repositories, :forks, :integer
    add_column :repositories, :open_issues, :integer
    add_column :repositories, :watchers, :integer
    add_column :repositories, :source, :string
    
  end
end