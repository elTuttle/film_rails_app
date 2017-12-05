class Movie < ActiveRecord::Base
  has_many :actor_movies
  has_many :actors, through: :actor_movies
  has_many :ratings

  accepts_nested_attributes_for :actors, reject_if: proc { |attributes| attributes['name'].blank? }

  validates :title, presence: true, uniqueness: true

  def avg_review
    if self.ratings.size > 0
      counter = 0
      movie_score = 0
      self.ratings.all.each do |rating|
        movie_score += rating.score
        counter += 1
      end
      movie_score/counter
    end
  end

end
