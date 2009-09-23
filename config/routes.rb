ActionController::Routing::Routes.draw do |map|
  map.resources :users,:collection => {:search => :get} do |user|
    user.resource :portrait
    user.resource :true_portrait
    user.resources :searched_contents
    user.resources :controlled_keywords
    user.resources :be_follows
    user.resources :follows,:new => {:search_user => :get}
    user.resources :keyword_pages
    user.resources :resources,
      :collection => {:authority => :get,:not_authority => :get} do |resource|
      resource.resources :comments,:collection => {:by_time => :get} do |comment|
        comment.resources :replied_comments
      end
    end
    user.resources :blog_resources
    user.resources :twitter_resources do |twitter_resource|
      twitter_resource.resources :replies
    end
    user.resources :news
    user.resources :link_url_resources,
      :member => {:add_value =>:post,:minus_value => :post }
  end
  map.resource :session
  map.resources :keyword_pages,:member => {:by_time => :get} do |keyword_page|
    keyword_page.resources :related_keywords
  end
  map.resources :searched_keywords
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
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
