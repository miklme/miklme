class TwitterResourcesController < ApplicationController
  def new
  end

  def show
  end

  def edit
  end

  def index
  end

  def create
    if  params[:keywords] !~%r{[a-zA-z]+://[^\s]*}
      @resource.save!
      flash[:notice]='<p>你说了一些不知道是什么东西的东西。不过你看，我们已经把它加上去了。</p>
<p>你可以选择回到Michael页面，搜索一下你刚才的胡言乱语试试。</p>
        <p>或者开始另一段胡言乱语.</p>'
      redirect_to user_path(current_user)
    elsif
      params[:keywords] =~ %r{[a-zA-z]+://[^\s]*}
      @known_link_url_resource= Resource.scoped_by_link_url(params[:keywords]).by_owner_value.first
      flash[:link_url]=params[:keywords]
      redirect_to new_user_link_url_resource_path(current_user)
    end
  end
end
