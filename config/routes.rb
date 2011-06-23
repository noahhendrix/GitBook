Gitbook::Application.routes.draw do
  match '/auth/:provider/callback' => 'sessions#create'
  match '/signout' => 'sessions#destroy', as: :signout
  
  match 'auth/*rest' => 'application#omniauth'
  
  match ':username/:repository' => 'repositories#show', as: :repository
  match ':username' => 'repositories#index', as: :repositories

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'welcome#index'
end
