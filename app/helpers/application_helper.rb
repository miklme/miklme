# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def link_to_follower(id)
    User.find(id)
  end

  def my_value_here(keyword_page)
    if logged_in?
      "我在此的声望：<cite>#{current_user.field_value(keyword_page)}</cite>"
    end
  end
  def link_to_page(keyword_page)
    link_to keyword_page.keyword,keyword_page_path(keyword_page)
  end
end
