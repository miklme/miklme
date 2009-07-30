class RelatedKeywordsController < ApplicationController
  before_filter :find_user_and_searched_keyword
  auto_complete_for :keyword,:name
  def index
    @related_keywords=@keyword.related_keywords
  end

  def new
    @related_keyword=@keyword.related_keywords.build
  end

  def edit
  end

  def show
  end

  def create
    @related_keyword=@keyword.related_keywords.build(params[:related_keyword])
    if @related_keyword.save
      flash[:notice]="修改成功"
      redirect_to keyword_related_keywords_path(@keyword)
    else
      render :action => :new
    end
  end
  def find_user_and_searched_keyword
    user_searched_keyword
  end
end
