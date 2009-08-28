class SearchedContentController < ApplicationController

  def new
    render :layout => "searched_keywords"
  end


  def show
    @twitter_resources=TwitterResource.search_by_content(params[:twitter_resource][:content],params[:page])
  end

end
