# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def link_to_follower(id)
    User.find(id)
  end

  def link_to_origin(resource)
    link_to(image_tag(preview_user_resource_path(resource.owner,resource, :jpg)),origin_user_resource_path(resource.owner,resource,:jpg), :popup => ['预览', 'height=400,width=540']) if resource.has_image?
  end

  def my_value
    if logged_in?
      "<h2>我的声望：<span id='hp'>#{number_with_precision current_user.value}</span></h2>"
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

  def link_to_resource_comments_path(resource)
    "<span class='reply_botton'>"+\
      link_to("<span class='reply_link'>回应#{resource.owner.nick_name}<span class='amount'>(#{resource.comments.size})</span></span>", user_resource_comments_path(resource.owner,resource),:popup => true)+\
      "</span>"
  end

  def link_to_reply_path(comment)
    link_to_remote "回应#{comment.owner.nick_name}",:url => {:controller => :replied_comments,:action => :new,:id => comment}
  end

  def variable_content(resource)
    users=resource.keyword_page.users_have_resources
    user_order=users.index(resource.owner).to_i+1
    #计算字体大小的公式
    v=(1-(user_order-1).to_f/(users.size-1).to_f)*10+8
    "<span style='font-size:#{v}px' id='resource_content_#{resource.id}'>"+\
      auto_link(h(resource.content))+\
      "</span>"
  end

  def variable_nick_name(user,keyword_page)
    user_order=keyword_page.users_have_resources.index(user).to_i+1
    users=keyword_page.users_have_resources
    #计算用户名大小的公式
    v=(1-(user_order-1).to_f/(users.size-1).to_f)*21+9
    "<div style='font-size:#{v}px'>"+\
      link_to(user.nick_name,user_path(user)) +\
      "</div>"
  end

  def comment_action(comment)
    if comment.rating==1
      attitude="<cite>支持</cite>"
    elsif comment.rating==0
      attitude="回应"
    elsif comment.rating==-1
      attitude="<strong>攻击</strong>"
    end
    if comment.action_one.present?
      action="#{h comment.action_one}了#{comment.parent.owner.nick_name}#{h comment.action_two}"+"并"
    end
    owner=link_to comment.parent.owner.nick_name,user_path(comment.parent.owner)
    user=link_to comment.owner.nick_name,user_path(comment.owner)
    user+action.to_s+\
    attitude+"了"+owner
  end
end
