class BookSerializer < ActiveModel::Serializer
  attributes :id, :name, :available, :genres, :authors, :publisher
end

