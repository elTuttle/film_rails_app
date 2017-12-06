class Actor < ActiveRecord::Base
  has_many :actor_movies
  has_many :movies, through: :actor_movies

  validates :name, presence: true, uniqueness: true

  def best_movie
    best = nil
    self.movies.each do |movie|
      if best == nil
        best = movies
      else
        if best.avg_review < movie.avg_review
          best = movie
        end
      end
    end
    best
  end

end
