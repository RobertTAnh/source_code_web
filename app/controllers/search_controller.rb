class SearchController < ApplicationController
  def show
    @theme_option_seo_noindex = true
    SearchOps::GeneralSearch.new(self).call
  end
end
