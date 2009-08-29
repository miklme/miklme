class SearchedContentsController < ApplicationController

  def new
    render :layout => "searched_keywords"
  end


  def show
    if !params[:twitter_resource].nil?
      @content = params[:twitter_resource][:content]
      session[:content] = @content
    else
      @content = session[:content]
    end
    s = Ferret::Search::SortField.new(:by_user_value, :reverse => false)
    @twitter_resources=TwitterResource.find_with_ferret(@content,:page=> params[:page],:per_page => 15,:sort => s)
  end

end
