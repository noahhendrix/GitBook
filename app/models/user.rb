class User < ActiveRecord::Base
  
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
