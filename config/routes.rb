ActionController::Routing::Routes.draw do |map|
  map.resources :users,:collection => {:search => :get} do |user|
    user.resource :portrait
    user.resource :true_portrait
    user.resources :controlled_keywords
    user.resources :be_follows
    user.resources :follows,:collection => {:top_20 => :get}
    user.resources :keyword_pages
    user.resources :resources ,:member => {:origin => :get,:preview => :get} do |resource|
      resource.resources :comments,:collection => {:by_time => :get} do |comment|
        comment.resources :comments
      end
    end
    user.resources :news
  end
  map.resource :session
  map.resources :keyword_pages,:collection => {:friends => :get} do |keyword_page|
    keyword_page.resources :related_keywords
    keyword_page.resources :resources
  end
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.root :controller=>'keyword_pages',:action=>'index'
  map.invite '/users/new/:inviter_id/',:controller => 'users',:action => "invite"
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
