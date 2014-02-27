Musgroups::Application.routes.draw do
  resources :concerts
  get '/groups/:group_id/tours/:tour_id/concerts/:id/edit' => 'concerts#edit', as: 'edit_tour_concert'
  get '/groups/:group_id/tours/:tour_id/concerts/new' => 'concerts#new', as: 'new_tour_concert'

  resources :tours
  get '/groups/:group_id/tours' => 'tours#index', as: 'group_tours'
  get '/groups/:group_id/tours/:id/concerts' => 'tours#show', as: 'group_tour'
  get '/groups/:group_id/tours/:id/edit' => 'tours#edit', as: 'edit_group_tour'
  get '/groups/:group_id/tours/new' => 'tours#new', as: 'new_group_tour'

  resources :songs
  get '/groups/:group_id/songs' => 'songs#index', as: 'group_songs'
  get '/groups/:group_id/songs/new' => 'songs#new', as: 'new_group_song'
  get '/groups/:group_id/songs/:id/edit' => 'songs#edit', as: 'edit_group_song'
  
  resources :members
  get '/groups/:group_id/members' => 'members#index', as: 'group_members'
  get '/groups/:group_id/members/new' => 'members#new', as: 'new_group_member'
  get '/groups/:group_id/members/:id/edit' => 'members#edit', as: 'edit_group_member'

  resources :groups
  get '/groups/:id/edit' => 'groups#edit', as: 'edit_group_path'

  get '/task' => 'groups#task', as: 'task'

  root 'groups#index', as: 'index', via: :all

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
