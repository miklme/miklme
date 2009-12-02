class InvitesController < ApplicationController
  def new
    @news=News.list_self_news(current_user)
  end

end
