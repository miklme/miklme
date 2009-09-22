class CommentsController < ApplicationController
  before_filter :load_user_and_resource
  skip_before_filter :login_required,:only => [:index,:by_time]
  # GET /comments
  # GET /comments.xml
  
  def index
    @keyword_page=KeywordPage.find_by_keyword(@resource.keywords)
    @related_keywords=@keyword_page.related_keywords
    @comments=@resource.comments_by_value(params[:page])
    @comment=@resource.comments.build
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  def by_time
    @keyword_page=KeywordPage.find_by_keyword(@resource.keywords)
    @related_keywords=@keyword_page.related_keywords
    @comments=@resource.comments_by_time(params[:page])
    @comment=@resource.comments.build
    render :action => :index
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
      u=User.find(@comment.resource.owner)
      if not u==current_user
        if current_user.value(@resource.keyword_page)<0 and params[:comment][:rating].to_i<0
          flash[:notice]="不太爽的是，这个领域内你的价值点数低于0了，暂时不能作出这种中肯评价。"
        elsif current_user.value(@resource.keyword_page)>=0 and params[:comment][:rating].to_i<0
          flash[:notice]="差评成功，你的价值点数降低了0.5，对方降低了1.0"
          u.change_value(@resource.keyword_page,params[:comment][:rating].to_i)
          current_user.change_value(@resource.keyword_page,-0.5)
          current_user.save
        else
          flash[:notice]="评论成功"
          u.change_value @resource.keyword_page,params[:comment][:rating].to_i
          u.save
        end
      end
      n=@resource.owner.news.create
      n.news_type="comment"
      n.comment=@comment
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
    @resource=Resource.find(params[:resource_id])
  end
end
