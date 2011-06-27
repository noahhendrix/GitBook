Gitbook::Application.routes.draw do
  match '/auth/:provider/callback' => 'sessions#create'
  match '/auth/*rest' => 'application#omniauth'
  match '/signout' => 'sessions#destroy', as: :signout
  
  post '/:commentable/:commentable_id/comments' => 'comments#create',
        :as => :post_comment
  delete '/:commentable/:commentable_id/comments/:id' => 'comments#destroy',
        :as => :destroy_comment
  
  match '/:username/:repository/page/:page' => 'repositories#show',
        constraints: { page: /\d+/ }
  match '/:username/:repository/*misc' => redirect("/%{username}/%{repository}")
  match '/:username/:repository' => 'repositories#show', as: :repository
  match '/:username' => 'repositories#index', as: :repositories

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'welcome#index'
end
