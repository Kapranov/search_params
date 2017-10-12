class SingleSort < ApplicationRecord
  belongs_to :book
  belongs_to :list

  validates_presence_of :book_id, :list_id, :position
  validates_uniqueness_of :book_id, scope: :list_id
end
