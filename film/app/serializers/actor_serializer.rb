class ActorSerializer < ActiveModel::Serializer
  attributes :id, :name, :age, :bio
  has_many :movies
end
