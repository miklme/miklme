class StartController < ApplicationController
  auto_complete_for :resource,:keywords
  def michael

  end
  def search
    @resources=Resource.find_by_keywords(params[:keywords])
    render :update do |page|
      page.redirect_to resources_path(@resources)
    end
  end
end
