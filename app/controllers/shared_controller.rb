class SharedController < ApplicationController
  skip_before_filter :login_required
  def about_us
  end

  def principles

  end
  def value
    render :layout => false
  end
end
