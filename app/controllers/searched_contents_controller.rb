class SearchedContentsController < ApplicationController

  def new
    render :layout => "searched_keywords"
  end


  def show
    @content=params[:twitter_resource][:content] || ''
    @twitter_resources=TwitterResource.find_with_ferret(@content)
  end

end
