class Rating < ActiveRecord::Base
  belongs_to :movie

  validates :score, presence: true

end
