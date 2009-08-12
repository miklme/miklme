class TwitterResourcesController < ApplicationController
  before_filter :find_user
  def new
  end

  def show
  end

  def edit
  end

  def index
    @twitter_resources=@user.twitter_resources
    @reply=@twitter_resource.replies.build
    @reply.owner=current_user
  end

  def create
    @twitter_resource=@user.twitter_resources.build(params[:twitter_resource])
    if  @twitter_resource.save and @twitter_resource.errors.blank?
      flash[:notice]='<p>你说了一些不知道是什么东西的东西。你可以选择回到Michael页面，搜索一下你刚才的胡言乱语试试。</p>
<p></p>
        <p>或者开始另一段胡言乱语.</p>'
      @twitter_resource.create_keyword_page(:keyword => @twitter_resource.keywords)
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
