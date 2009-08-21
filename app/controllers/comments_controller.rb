class CommentsController < ApplicationController
  before_filter :load_user_and_resource

  # GET /comments
  # GET /comments.xml
  
  def index
    @keyword_page=KeywordPage.find_by_keyword(@resource.keywords)
    @related_keywords=@keyword_page.related_keywords
    @comments = @resource.comments.parent_comments.by_owner_value
    @comment=@resource.comments.build
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
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

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = @resource.comments.build(params[:comment])
    @comment.owner=current_user
    if @comment.save
      u=User.find(params[:user_id])
      u.value =u.value+params[:comment][:value].to_i
      u.save
      n=@resource.owner.news.create
      n.news_type="comment"
      n.resource=@resource
      n.save
      redirect_to :back
    else
      render :action => "new" 
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])

        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to(@comment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
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
    @resource=LinkUrlResource.find(params[:link_url_resource_id])
  end
end
