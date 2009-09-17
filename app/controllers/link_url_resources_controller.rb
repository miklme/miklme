class LinkUrlResourcesController < ApplicationController
  before_filter :find_user,:except => [:auto_complete_for_keyword_page_keyword]
  auto_complete_for :keyword_page,:keyword,:limit => 7
  def new
    @link_url_resource=current_user.link_url_resources.build
  end

  def edit
    @link_url_resource=LinkUrlResource.find(params[:id])
  end

  def create
    @link_url_resource=current_user.link_url_resources.build(params[:link_url_resource])
    @link_url_resource.keywords=params[:keyword_page][:keyword]
    if @link_url_resource.save
      KeywordPage.create(:keyword => @link_url_resource.keywords)
      render :partial => "succeed",:layout => "link_url_resources"
      n=current_user.news.create
      n.news_type="link_url_resource"
      n.owner=current_user
      n.resource=@link_url_resource
      n.save
    else
      render :action => :new,:layout => "link_url_resources"
    end
  end

  def update
    @link_url_resource=@user.link_url_resources.find(params[:id])
    @link_url_resource.update_attributes(params[:link_url_resource])
    @link_url_resource.keywords=params[:keyword_page][:keyword]
    if @link_url_resource.save
      KeywordPage.create(:keyword => @link_url_resource.keywords)
      flash[:notice]="修改成功。"
      redirect_to keyword_page_path(KeywordPage.find_by_keyword(@link_url_resource.keywords))
    else
      render :action => :edit,:layout => "link_url_resources"
    end
  end

#  暂时视图中没有这个功能。
#  def minus_value
#    o=Resource.find(params[:id]).owner
#    if current_user.value<0
#      flash[:notice]="不太爽的是，你的价值点数低于0了，暂时不能作出这种评价。"
#      redirect_to :back
#    else
#      o.value=o.value-0.6
#      current_user.value=current_user.value-0.3
#      current_user.save
#      o.save
#      flash[:notice]="感谢反馈。"
#      redirect_to :back
#    end
#  end

  private
  def find_user
    @user=User.find(params[:user_id])
  end
end
