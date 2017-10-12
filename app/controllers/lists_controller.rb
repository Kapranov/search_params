class ListsController < ApplicationController
  def books
    #@lists = Book.order("available DESC").limit(5)
    #@lists = Book.limit(5).order('available DESC').pluck(:available)
    @lists = Book.reorder('available desc').limit(5)
    #@lists = List.find(154).books.limit(5)
    #@lists = List.order("name DESC").limit(5)
    render json: @lists
  end
end
