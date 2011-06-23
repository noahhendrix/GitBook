class User < ActiveRecord::Base
  
  #associations
    has_many :repositories
  
  #attributes
    def avatar_url(size=48)
      gravatar_id = Digest::MD5.hexdigest(email.downcase)
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=#{CGI.escape(DEFAULT_AVATAR_URL)}"
    end
  
  #constants
    DEFAULT_AVATAR_URL = '/images/guest.png'
  
  #class methods
    def self.create_with_omniauth(auth)
      create! do |user|
        user.provider = auth['provider']
        user.uid = auth['uid']
        user.name = auth['user_info']['nickname']
        user.email = auth['user_info']['email']
      end
    end
  
end
