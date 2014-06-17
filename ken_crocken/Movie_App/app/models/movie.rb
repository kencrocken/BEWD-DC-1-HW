class Movie < ActiveRecord::Base
  validates :title, presence: true
  validates :description, length: {minimum: 10}
  validates :year_released, length: {minimum: 4}
  validates :rating, :numericality => {:less_than_or_equal_to =>5, :greater_than_or_equal_to => 0}, allow_blank: true

  def self.search_movie argument
    Movie.where("title LIKE :query OR description LIKE :query OR year_released LIKE :query", query: "%#{argument}%")
  end
end
