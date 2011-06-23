class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  
  def omniauth
    #a blank method used to allow omniauth urls to pass
    #without be routed as username/respoitory
    render text: 'Authentication', status: 404
  end
  
  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
