class RepositoriesController < ApplicationController
  
  respond_to :html, :json
  
  def index
    @user = User.find_or_create_by_name(params[:username])
  end

  def show
    @repository = Repository.find_or_create(params[:username], params[:repository])
    @timeline = @repository.sorted_timeline(params[:page])
    respond_with(@repository)
  end

end
