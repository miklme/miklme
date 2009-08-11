class RepliesController < ApplicationController
  before_filter :find_user_and_resource
  # POST /replies
  # POST /replies.xml
  def create
    @reply = current_user.replies.build(params[:reply])
    @reply.resource=@twitter_resource
    respond_to do |format|
      if @reply.save
        u=User.find(params[:user_id])
        u.value=u.value+0.2
        u.save
        format.html { redirect_to :back }
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
