class RepliesController < ApplicationController
  before_filter :find_user_and_resource
  # POST /replies
  # POST /replies.xml
  def new
    @reply=@twitter_resource.replies.build
  end

  def create
    @reply = @twitter_resource.replies.build(params[:reply])
    @reply.owner=current_user
    respond_to do |format|
      if @reply.save
        u=User.find(params[:user_id])
        u.value=u.value+0.2
        u.save
        n=@twitter_resource.owner.news.create
        n.owner=@twitter_resource.owner
        n.resource=@twitter_resource
        n.news_type="twitter_resource_reply"
        n.save
        format.html { render :text => "回复成功，可以刷新页面试试。" }
        format.xml  { render :xml => @reply, :status => :created, :location => @reply }
      else
        format.html {  redirect_to :back }
        format.xml  { render :xml => @reply.errors, :status => :unprocessable_entity }
      end
    end
  end
  # DELETE /replies/1
  # DELETE /replies/1.xml
  def destroy
    @reply = @twitter_resource.replies.find(params[:reply_id])
    @reply.destroy

    respond_to do |format|
      format.html { redirect_to(replies_url) }
      format.xml  { head :ok }
    end
  end

  private
  def find_user_and_resource
    @user=User.find(params[:user_id])
    @twitter_resource=@user.twitter_resources.find(params[:twitter_resource_id])
  end
end
