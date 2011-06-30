class Issue < RepositoryEvent
  
  #attributes
   def url
    "#{Repository::GITHUB_BASE_URL}/#{repository.slug}/issues/#{number}"
   end

  #mapping API hash to DB
    def self.map_api(api_hash)
      {
        type: 'Issue',
        number: api_hash['number'],
        username: api_hash['user']['login'],
        title: api_hash['title'],
        body: api_hash['body'],
        occurred_at: api_hash['created_at'],
        url: api_hash['html_url']
      }
    end
    
end