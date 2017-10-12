class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :name, :genres, :authors
end
