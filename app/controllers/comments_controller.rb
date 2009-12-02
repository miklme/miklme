class CommentsController < ApplicationController
  before_filter :load_user_and_resource,:except =>  [:auto_complete_for_keyword_page_keyword]
  skip_before_filter :login_required,:only => [:index,:auto_complete_for_keyword_page_keyword]
  # GET /comments
  # GET /comments.xml
  def index
    @keyword_page=KeywordPage.find_by_keyword(@resource.keyword_page.keyword)
    if logged_in? and !current_user.keyword_pages.include?(@keyword_page)
      current_user.keyword_pages<<@keyword_page
    end
    @comments=@resource.comments_by_time(params[:page])
    @comment=@resource.comments.build
    respond_to do |format|
      format.html
      format.jpg
    end
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = @resource.comments.build(params[:comment])
    @comment.owner=current_user
    notice=comment_notice(@comment)
    session[:before]=@resource.owner.value
    if @comment.save
      flash[:notice]=notice
      change_user_value(@comment)
      changed_value=@resource.owner.value-session[:before]
      News.create_comment_news(@comment,@resource,changed_value)
      redirect_to user_resource_comments_path(@resource.owner,@resource)
    else
      redirect_to user_resource_comments_path(@resource.owner,@resource)
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
  
  private

  def load_user_and_resource
    @user=User.find(params[:user_id])
    @resource=Resource.find(params[:resource_id])
  end
end
