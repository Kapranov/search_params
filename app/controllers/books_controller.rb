class BooksController < ApplicationController
  def index
    @books = Book.all
    render json: @books
  end

  def show
    @book = Book.find(params[:id])
    render json: @book
  end

  def search
    filter = params[:filter] || nil
    books = []
    books = Book.where('name LIKE ?'\
                       'OR authors LIKE ? '\
                       'OR genres LIKE ?'\
                       'OR publisher LIKE ?'\
                       , "%#{filter}%", "%#{filter}%", "%#{filter}%", "%#{filter}%") if filter
    render json: books
  end
end
