require 'httparty'
require 'hashie'

class GitHubFetch
  include HTTParty
  
  class NotFound < Exception; end;
  GITHUB_URI = 'https://api.github.com'
  
  headers 'Accept' => [
    'application/json'
  ].join(';')
  
  default_params :output => 'json'
  
  def initialize(slug, opts = {})
    @slug = slug
    self.class.base_uri "#{GITHUB_URI}/repos/#{slug}"
    validate_existance if opts[:validate] === true
  end
  
  def info
    get('')
  end
  alias_method :validate_existance, :info
  
  def commits
    get('/commits')
  end
  
  def unfiltered_issues(params = {})
    get('/issues', params)
  end
    
    def issues(params = {})
      unfiltered_issues(params).keep_if { |i| i['pull_request']['html_url'].nil? }
    end
    
    def pulls(params = {})
      unfiltered_issues(params).delete_if { |i| i['pull_request']['html_url'].nil? }
    end
  
  def self.all_for_user(username)
    response = get("#{GITHUB_URI}/users/#{username}/repos")
    raise NotFound if response.not_found?
    response.parsed_response.map! { |h| Hashie::Mash.new(h) }
  end
  
  private
  
  def get(path, params = {})
    response = self.class.get(path, query: params)
    raise NotFound if response.not_found?
    if response.parsed_response.is_a?(Hash)
      Hashie::Mash.new(response.parsed_response)
    else
      response.parsed_response.map! { |h| Hashie::Mash.new(h) }
    end
  end
  
end