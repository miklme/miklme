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
    session[:before]=@comment.owner.field_value(@resource.keyword_page)
    if @replied_comment.save
      change_user_value(@replied_comment)
      changed_value=@comment.owner.field_value(@resource.keyword_page)-session[:before]
      News.create_replied_comment_news(@replied_comment, @resource,changed_value)
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
