class SearchController < ApplicationController

  skip_authorization_check

  def index
  end

  def search
    if params[:query] != ""
      search = Services::Search.new
      search.call(params)
      @items = search.items
      @meta = search.meta
      !@items.empty? ? (render :index) : (redirect_to questions_path, notice: 'Search results empty or not found')
    else
      redirect_to questions_path, notice: 'Search results empty or not found'
    end
  end
end
