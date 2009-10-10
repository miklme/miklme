class CommentsController < ApplicationController
  before_filter :load_user_and_resource,:except => [:show_hidden]
  skip_before_filter :login_required,:only => [:index,:by_time,:show_hidden]
  # GET /comments
  # GET /comments.xml
  
  def index
    @keyword_page=KeywordPage.find_by_keyword(@resource.keyword_page.keyword)
    if logged_in? and !current_user.keyword_pages.include?(@keyword_page)
      v=ValueOrder.new
      v.user=current_user
      v.keyword_page=@keyword_page
      v.save
    end
    @related_keywords=@keyword_page.related_keywords
    @comments=@resource.comments_by_time(params[:page])
    @comment=@resource.comments.build
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = @resource.comments.build(params[:comment])
    if not current_user.keyword_pages.include?(@keyword_page)
      v=ValueOrder.find_by_keyword_page_id_and_user_id(@resource.keyword_page.id,current_user.id)
      v.actived=true
      v.save
    end
    @comment.owner=current_user
    if @comment.save
      u=User.find(@comment.resource.owner)
      if not u==current_user
        if current_user.field_value(@resource.keyword_page)<0 and params[:comment][:rating]=="-1"
          flash[:notice]="这个关键字内你的声望低于0了，暂时不能作出这种评价。"
        elsif current_user.field_value(@resource.keyword_page)>=0 and params[:comment][:rating]=="-1"
          flash[:notice]="差评成功，对方降低了一定声望，不过你也有所降低。"
          u.change_value(@resource.keyword_page,-@resource.keyword_page.comment_value(current_user))
          current_user.change_value(@resource.keyword_page,-@resource.keyword_page.comment_value(current_user)/2)
          current_user.save
        elsif params[:comment][:rating]=="1"
          flash[:notice]="回应成功"
          u.change_value @resource.keyword_page,@resource.keyword_page.comment_value(current_user)
          u.save
        end
      end
      n=@resource.owner.news.create
      n.news_type="be_comment"
      n.comment=@comment
      n.resource=@resource
      n.save
      n_2=current_user.news.create
      n_2.news_type="comment"
      n_2.comment=@comment
      n_2.resource=@resource
      n_2.save
      redirect_to :back
    else
      redirect_to :back
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(comments_url) }
      format.xml  { head :ok }
    end
  end
  def show_hidden
    render :update do |page|
      page.visual_effect :toggle_appear,"notice"
    end
  end
  private

  def load_user_and_resource
    @user=User.find(params[:user_id])
    @resource=Resource.find(params[:resource_id])
  end
end
