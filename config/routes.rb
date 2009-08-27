ActionController::Routing::Routes.draw do |map|
  map.resources :users,:collection => {:search => :get} do |user|
    user.resources :controlled_keywords
    user.resource :portrait
    user.resources :searched_keywords
    user.resources :searched_content
    user.resource :true_portrait
    user.resources :be_follows
    user.resources :follows,:new => {:search_user => :get}
    user.resources :resources
    user.resources :controlled_keywords
    user.resources :blog_resources
    user.resources :twitter_resources do |twitter_resource|
      twitter_resource.resources :replies
    end
    user.resources :news
    user.resources :keywords
    user.resources :link_url_resources,
      :member => {:add_value =>:post,:minus_value => :post },
      :collection => {:authority => :get,:not_authority => :get} do |link_url_resource|
      link_url_resource.resources :comments do |comment|
        comment.resources :replied_comments
      end
    end
  end
  map.resource :session
  map.resources :keyword_pages do |keyword_page|
    keyword_page.resources :related_keywords
  end
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
