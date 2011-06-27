class RepositoriesController < ApplicationController
  
  respond_to :html, :json
  
  def index
    @username = params[:username]
    @repositories = Repository.fetch_all_repositories_for_user(params[:username])
  end

  def show
    @repository = Repository.find_or_create(params[:username], params[:repository])
    @timeline = @repository.sorted_timeline(params[:page])
    respond_with(@repository)
  end

end
