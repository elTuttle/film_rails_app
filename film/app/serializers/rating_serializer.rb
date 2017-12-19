class RatingSerializer < ActiveModel::Serializer
  attributes :id, :content, :score
  belongs_to :movie
  belongs_to :user
end
