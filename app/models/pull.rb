class Pull < RepositoryEvent

  #mapping API hash to DB
    def self.map_api(api_hash)
      {
        type: 'Pull',
        number: api_hash['number'],
        username: api_hash['user']['login'],
        title: api_hash['title'],
        body: api_hash['body_html'],
        occurred_at: api_hash['created_at'],
        url: api_hash['html_url']
      }
    end
end
