class RepliedCommentsController < ApplicationController
  before_filter :find_parent,:only => :create
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
    @replied_comment=@resource.comments.build(params[:comment])
    @replied_comment.parent_comment=@comment
    @replied_comment.owner=current_user
    if @replied_comment.save
      calculate_comment_value(@replied_comment)
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
      render :update do |page|
        page.replace "form",:partial => "comments/comment",:object => @replied_comment
        page.visual_effect :pulsate,"comment_#{@replied_comment.id}",:duration => 3
      end
    else
      render :action => :new
    end
  end
  private
  def find_parent
    @resource=Resource.find(params[:resource_id])
    @comment=Comment.find(params[:comment_id])
  end

end
