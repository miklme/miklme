class RepliedCommentsController < ApplicationController
  before_filter :find_user_and_resource_and_comment
  def new
    @replied_comment=@link_url_resource.comments.build
  end

  def create
    @replied_comment=@link_url_resource.comments.build(params[:comment])
    @replied_comment.parent_comment=@comment
    @replied_comment.owner=current_user
    if @replied_comment.save
      n=@replied_comment.parent_comment.owner.news.build
      n.news_type="replied_comment"
      n.resource=@link_url_resource
      n.comment=@replied_comment
      n.save
      redirect_to :back
    else
      render :action => :new
    end
  end

  def find_user_and_resource_and_comment
    @user=User.find(params[:user_id])
    @link_url_resource=Resource.find(params[:link_url_resource_id])
    @comment=Comment.find(params[:comment_id])
  end
end
