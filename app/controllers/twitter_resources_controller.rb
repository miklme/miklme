class TwitterResourcesController < ApplicationController
  before_filter :find_user
  layout "comments"
  def new
  end

  def show
  end

  def edit
  end

  def index
    @twitter_resources=@user.twitter_resources
  end

  def create
    @twitter_resource=@user.twitter_resources.build(params[:twitter_resource])
    if  @twitter_resource.save and @twitter_resource.errors.blank?
      flash[:notice]='<p>你说了一些不知道是什么东西的东西。你可以选择回到Michael页面，搜索一下你刚才的胡言乱语试试。</p>
<p></p>
        <p>或者开始另一段胡言乱语.</p>'
      @twitter_resource.create_keyword_page(:keyword => @twitter_resource.keywords)
      n= current_user.news.create
      n.owner=current_user
      n.resource=@twitter_resource
      n.news_type="twitter_resource"
      n.save
      redirect_to user_path(current_user)
    else
      render "resources/index"
    end
  end
  private
  def find_user
    @user=User.find(params[:user_id])
  end
end
