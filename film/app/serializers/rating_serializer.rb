class RatingSerializer < ActiveModel::Serializer
  attributes :id, :content, :score
  belongs_to :movie
end
