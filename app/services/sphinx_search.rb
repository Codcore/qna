module Services
  class SphinxSearch

    ALLOWED_SEARCH_TYPES = ['question', 'answer', 'commentary', 'user']

    def get_search_results(params = {})
      @page = params[:page] || 1
      @per_page = params[:per_page] || 10
      @search_text = params[:search_text]
      @search_type = params[:type]

      if @search_type.in? ALLOWED_SEARCH_TYPES
        params[:type].capitalize!.constantize.search(@search_text, page: @page, per_page: @per_page)
      else
        ThinkingSphinx.search(@search_text, page: @page, per_page: @per_page)
      end
    end
  end
end