# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def link_to_follower(id)
    User.find(id)
  end

  def link_to_origin(resource)
      link_to(image_tag(preview_user_resource_path(resource.owner,resource, :jpg)),origin_user_resource_path(resource.owner,resource,:jpg), :popup => ['预览', 'height=400,width=540']) if resource.has_image? 
  end

  def my_value_here(keyword_page)
    if logged_in?
      "我在此的声望：<cite>#{current_user.field_value(keyword_page)}</cite>"
    end
  end
  def link_to_page(keyword_page)
    link_to keyword_page.keyword,keyword_page_path(keyword_page)
  end

  def order(user,keyword_page)
    if !keyword_page.users_have_resources.include?(user)
      user_order="N"
    else
      user_order=keyword_page.users_have_resources.index(user).+1
    end
    all_users=keyword_page.users_have_resources.size
    "(<span class='highlight'>
    #{user_order}
      </span>/ #{all_users})"
  end

  def calling(user)
    if user!=current_user
      if user.sex==1
        "他"
      else
        "她"
      end
    else
      "我"
    end
  end

end
