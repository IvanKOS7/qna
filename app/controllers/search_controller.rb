# frozen_string_literal: true

class SearchController < ApplicationController
  skip_authorization_check

  def index; end

  def search
    if params[:query].present?
      @items = Services::Search.call(params)
      @items.present? ? (render :index, notice: t('.success')) : (redirect_to questions_path, notice: t('search.failure'))
    else
      redirect_to questions_path, notice: t('search.failure')
    end
  end
end
