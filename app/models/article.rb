class Article < ApplicationRecord
  validates_presence_of :name, :body, :genres, :authors
end
