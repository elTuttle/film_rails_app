class MovieSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :user_id
  has_many :ratings
  has_many :actors
end
