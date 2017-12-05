class Movie < ActiveRecord::Base
  has_many :actor_movies
  has_many :actors, through: :actor_movies
  has_many :reviews

  accepts_nested_attributes_for :actors, reject_if: proc { |attributes| attributes['name'].blank? }

  validates :title, presence: true, uniqueness: true

  def avg_review
    counter = 0
    movie_score = 0
    self.reviews.all.each do |review|
      movie_score += review.score
      counter++
    end
    movie_score/counter
  end

end
