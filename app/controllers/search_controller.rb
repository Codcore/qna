class SearchController < ApplicationController


  def create
    @search_results = Services::SphinxSearch.new.get_search_results(page: params[:page],
                                                                    search_text: params[:search_text],
                                                                    type: params[:type])
  end
end