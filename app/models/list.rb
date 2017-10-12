class List < ApplicationRecord
  has_many :single_sorts
  has_many :books, through: :single_sorts, source: :book

  validates_presence_of :name
end
