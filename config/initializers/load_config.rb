APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, APP_CONFIG['github_id'], APP_CONFIG['github_secret']
end

HoptoadNotifier.configure do |config|
  config.api_key = APP_CONFIG['hoptoad_api_key']
end
