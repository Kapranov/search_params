class ArticlesController < ApplicationController
  def index
    @articles = Article.all
    render json: @articles
  end

  def show
    @article = Article.find(params[:id])
    render json: @article
  end

  #def search
  #  filter = params[:filter] || nil
  #  articles = []
  #  articles = Article.where('name LIKE ?'\
  #                           'OR authors LIKE ? '\
  #                           'OR genres LIKE ?'\
  #                           , "%#{filter}%", "%#{filter}%", "%#{filter}%") if filter
  #  render json: articles
  #end

  def search
    limit = params[:limit] || 5
    page = params[:page] || 5
    offset = ((page.to_i - 1) * limit.to_i) || 0
    filter = params[:filter] || nil
    articles = []
    articles = Article.where('name LIKE ?'\
                             'OR authors LIKE ? '\
                             'OR genres LIKE ?'\
                             , "%#{filter}%", "%#{filter}%", "%#{filter}%").limit(limit).offset(offset) if filter
    render json: articles
  end
end
