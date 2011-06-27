class Commit < RepositoryEvent
  
  #attributes
    def url
      "#{Repository::GITHUB_BASE_URL}#{read_attribute(:url)}"
    end
  
  #mapping API hash to DB
    def self.map_api(api_hash)
      {
        type: 'Commit',
        username: api_hash[:author][:login],
        number: api_hash[:id],
        body: api_hash[:message],
        occurred_at: api_hash[:committed_date],
        url: api_hash[:url]
      }
    end
  
end
