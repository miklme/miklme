class TwitterResourcesController < ApplicationController
  before_filter :load_user
  def index
    @twitter_resources=TwitterResource.find_by_user(@user,params[:page])
  end

  def show
    @twitter_resource=TwitterResource.find(params[:id])
  end
  def create
    @twitter_resource=@user.twitter_resources.build(params[:twitter_resource])
    if  @twitter_resource.save and @twitter_resource.errors.blank?
      flash[:notice]='<p>成功。</p>
<p></p>
        <p>或者开始另一段胡言乱语.</p>'
      n= current_user.news.create
      n.owner=current_user
      n.resource=@twitter_resource
      n.news_type="twitter_resource"
      n.save
      redirect_to user_path(current_user)
    else
      render "users/show",:layout => "resources"
    end
  end

end
