task fetch_activity: :environment do
  
  Repository.find_each(batch_size: 50) do |r|
    r.fetch_recent_activity
  end
  
end