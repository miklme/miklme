class RepliedCommentsController < ApplicationController
  def new
    @comment=Comment.find(params[:id])
    @resource=@comment.resource
    @replied_comment=@resource.comments.build
    x="comments_for_#{params[:id]}"
    render :update do |page|
      page.insert_html :top,"#{x}",:partial => "form",:object => @replied_comment
    end
  end

  def create
    @user=User.find(params[:user_id])
    @resource=Resource.find(params[:blog_resource_id])
    @comment=Comment.find(params[:comment_id])
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


end
