task fetch_activity: :environment do
  
  Repository.find_each(batch_size: 50) do |r|
    r.add_info_fetch_to_queue(priority: 1)
  end
  
end