JrubyApp::Application.routes.draw do

  resources :user_preferences

  resources :products
  
  match "/product_details/:id", :to => "site#product_details", :as => :product_details
  
  match "/dashboard" => "dashboard#index", :as => :dashboard
  
  devise_scope :user do
		get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
	end
	devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_for :users

	match "/set_product_rating", :to => "user_preferences#set_product_rating"
  
  match '/assets/crop', :to => 'assets#crop'
	match '/assets/crop_image', :to => 'assets#crop_image'
	match "/assets/add_lookbook",:to => "assets#add_lookbook"
	match '/assets/upload_assets', :to => 'assets#upload_assets'
  match '/assets/delete_assets', :to => 'assets#delete_assets'
  match '/assets/logo', :to => 'assets#logo'
  match '/assets/add', :to => 'assets#add'
  match '/assets/:id/destroy', :to => 'assets#destroy'
  match '/assets/add_logo', :to => 'assets#add_logo'
  match '/assets/show_update_asset', :to => 'assets#show_update_asset'
  match '/assets/reorder', :to => 'assets#reorder'
  match '/assets/reorder_all', :to => 'assets#reorder_all'
	match '/assets/update', :to => 'assets#update'
	match '/assets/:id', :to => 'assets#show'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'site#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id))(.:format)'
end
