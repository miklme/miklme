class SearchedContentsController < ApplicationController
  def show
    if !params[:resource].nil?
      @content = params[:resource][:content]
      session[:content] = @content
    else
      @content = session[:content]
    end
    s = Ferret::Search::SortField.new(:by_user_value, :reverse => true)
    @link_url_resources=LinkUrlResource.find_with_ferret(@content+"~",:sort => s)
    @blog_resources=BlogResource.find_with_ferret(@content+"~",:sort => s)
    @resources=(@blog_resources+@link_url_resources).paginate(:page => params[:page],:per_page => 15)
  end

end
