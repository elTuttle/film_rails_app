class Movie < ActiveRecord::Base
  has_many :actor_movies
  has_many :actors, through: :actor_movies

  accepts_nested_attributes_for :actors, reject_if: proc { |attributes| attributes['name'].blank? }

end
