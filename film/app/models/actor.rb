class Actor < ActiveRecord::Base
  has_many :actor_movies
  has_many :films, through: :actor_movies

end
