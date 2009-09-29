class SearchedContentsController < ApplicationController
  skip_before_filter :login_required
  def show
    if !params[:keyword_page].nil?
      @keyword = params[:keyword_page][:keyword]
      session[:keyword] = @keyword
    else
      @keyword = session[:keyword]
    end
    s = Ferret::Search::SortField.new(:by_user_value, :reverse => true)
    @link_url_resources=LinkUrlResource.find_with_ferret(@keyword+"~",:sort => s)
    @blog_resources=BlogResource.find_with_ferret(@keyword+"~",:sort => s)
    @resources=(@blog_resources+@link_url_resources).paginate(:page => params[:page],:per_page => 15)
  end

end
