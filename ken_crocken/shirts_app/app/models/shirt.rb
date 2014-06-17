class Shirt < ActiveRecord::Base
  validates :name, presence: true
  validates :description, length: {minimum: 10}

  def self.search_shirt argument
    Shirt.where("name LIKE :query OR description LIKE :query", query: "%#{argument}%")
  end

end