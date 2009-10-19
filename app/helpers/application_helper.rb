# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def link_to_follower(id)
    User.find(id)
  end

  def link_to_value_help
    "总声望"
  end

  def link_to_resource(resource)
    if resource.class.to_s=="LinkUrlResource"
      link_to resource.description_or_title,resource.link_url,:popup => true,:class => "title"
    elsif resource.class.to_s=="BlogResource"
      link_to resource.description_or_title,user_blog_resource_path(resource.owner,resource),:popup => true,:class => "title"
    end
  end
  
  def link_to_page(keyword_page)
    link_to keyword_page.keyword,keyword_page_path(keyword_page)
  end
end
