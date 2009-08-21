module NewsHelper
  def via_keyword_to_keyword_page(keywords)
    KeywordPage.find_by_keyword(keywords)
  end

  def link_to_follower(id)
    User.find(id)
  end
end
