ActionController::Routing::Routes.draw do |map|
  map.resources :users do |user|
    user.resource :portrait
    user.resource :true_portrait
    user.resources  :friends
    user.resources :resources,:has_many => :markings
  end
  map.resources :resources do |resource|
    resource.resources :markings
  end
  map.resource :session
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.register '/register', :controller => 'users', :action => 'create'
  map.search '/search/:keywords',:controller => 'resources',:action => 'search'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.login'login',:controller => 'sessions',:action => 'new'
  map.root :controller=>'sessions',:action=>'new'

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
