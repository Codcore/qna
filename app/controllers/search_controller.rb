class SearchController < ApplicationController

  ALLOWED_SEARCH_TYPES = ['question', 'answer', 'commentary', 'user']

  def create
    @search_results = get_search_results
  end

  private

  def get_search_results
    @page = params[:page]
    @per_page = 10
    @search_text = params[:search]
    @search_type = params[:type]


    if @search_type.in? ALLOWED_SEARCH_TYPES
      params[:type].capitalize!.constantize.search(@search_text, page: @page, per_page: @per_page)
    else
      nil
    end
  end
end