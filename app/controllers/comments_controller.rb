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
    if @comment.save
      calculate_comment_value(@comment)
      flash[:notice]="回应成功。"
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
  
  private

  def load_user_and_resource
    @user=User.find(params[:user_id])
    @resource=Resource.find(params[:resource_id])
  end
end
