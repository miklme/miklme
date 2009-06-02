class UsersController < ApplicationController
  skip_before_filter :login_required

  def new
    @user=User.new
  end
  def create
   
    #logout_keeping_session!
    @user = User.new(params[:user])
 
    respond_to do |format|
      if @user.save
        format.html { render :update do |page|
            page.replace_html 'register',:partial=>'user_created'
              end
          }
          format.xml  { render :xml => @article, :status => :created, :location => @article }
        else
          format.html { render :update do |page|
              page.alert "很抱歉...没有注册成功，看看哪里打错了，再重试一下。"
            end }
          format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
        end
      end
    end

    def activate
      logout_keeping_session!
      user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
      case
      when (!params[:activation_code].blank?) && user && !user.active?
        user.activate!
        flash[:notice] = "注册成功，即刻将体验Michael带给您的...无限。"
        redirect_to '/login'
      when params[:activation_code].blank?
        flash[:error] = "The activation code was missing.  Please follow the URL from your email."
        redirect_back_or_default('/')
      else
        flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
        redirect_back_or_default('/')
      end
    end
  end
