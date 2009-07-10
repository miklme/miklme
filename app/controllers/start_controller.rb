class StartController < ApplicationController
  auto_complete_for :resource,:keywords,:limit => 50
  def michael

  end
 
  def search
    render :update do |page|
      page.redirect_to "/search/#{params[:keywords]}"
    end
  end
end
