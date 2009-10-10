class RepliedCommentsController < ApplicationController
  before_filter :find_user_and_resource_and_comment
  def new
    @replied_comment=@resource.comments.build
  end

  def create
    @replied_comment=@resource.comments.build(params[:comment])
    @replied_comment.parent_comment=@comment
    @replied_comment.owner=current_user
    if @replied_comment.save
      n=@replied_comment.parent_comment.owner.news.build
      n.news_type="be_replied_comment"
      n.resource=@resource
      n.comment=@replied_comment
      n.save
      n_2=current_user.news.build
      n_2.news_type="replied_comment"
      n_2.resource=@resource
      n_2.comment=@replied_comment
      n_2.save
      redirect_to user_resource_comments_path(@resource.owner,@resource)
    else
      render :action => :new
    end
  end

  private
  def find_user_and_resource_and_comment
    @user=User.find(params[:user_id])
    @resource=Resource.find(params[:resource_id])
    @comment=Comment.find(params[:comment_id])
  end
end
