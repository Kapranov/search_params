class Book < ApplicationRecord
  has_many :single_sorts
  has_many :lists, through: :single_sorts

  validates_presence_of :name, :genres, :authors, :publisher
  validates_inclusion_of :available, :in => [true, false]
end
