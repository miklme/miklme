class LinkUrlResourcesController < ApplicationController
  before_filter :find_user,:except => [:auto_complete_for_link_url_resource_keywords,:redirect_and_adjust_value]
  auto_complete_for :link_url_resource,:keywords,:limit => 7
  def new
    @link_url_resource=@user.link_url_resources.build
  end

  def edit
    @link_url_resource=LinkUrlResource.find(params[:id])
  end

  def index
    @link_url_resources=@user.link_url_resources
  end

  def show
    link_url_resource=LinkUrlResource.find(params[:id])
    if redirect_to "#{link_url_resource.link_url}"
      u=User.find(params[:user_id])
      u.value+=0.4
      u.save
    end
  end
  
  def create
    @link_url_resource=current_user.link_url_resources.build(params[:link_url_resource])
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
    if @link_url_resource.save
      flash[:updated]="修改成功。"
      render :action => :edit,:layout => "link_url_resources"
    end
  end

  def authority
    @authority_link_url_resources=@user.link_url_resources.scoped_by_authority(true)
  end

  def not_authority
    @not_authority_link_url_resources=@user.link_url_resources.scoped_by_authority(false)
  end

  def minus_value
    o=Resource.find(params[:id]).owner
    if not current_user==o
      o.value=o.value-0.4
      o.save
      flash[:notice]="创建这个链接的人减少了0.4点价值点数。"
      redirect_to :back
    end
  end

  private
  def find_user
    @user=User.find(params[:user_id])
  end
end
