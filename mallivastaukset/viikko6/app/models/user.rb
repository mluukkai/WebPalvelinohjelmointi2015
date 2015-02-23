class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true,
                       length: { in: 3..15 }

  validates :password, length: { minimum: 4 }

  validates :password, format: { with: /\d.*[A-Z]|[A-Z].*\d/,  message: "has to contain one number and one upper case letter" }

  def self.most_active(n)
    sorted_by_rating_in_desc_order = User.all.select{ |u| u.ratings.any? }.sort_by{ |u| -(u.ratings.count) }
    sorted_by_rating_in_desc_order[0..(n-1)]
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite(category)
    return nil if ratings.empty?

    categroy_ratings = rated(category).inject([]) do |set, item|
      set << {
        item: item,
        rating: rating_of(category, item) }
    end

    categroy_ratings.sort_by { |item| item[:rating] }.last[:item]
  end

  def favorite_brewery
    favorite :brewery
  end

  def favorite_style
    favorite :style
  end

  def rated(category)
    ratings.map{ |r| r.beer.send(category) }.uniq
  end

  def rating_of(category, item)
    ratings_of_item = ratings.select do |r|
      r.beer.send(category) == item
    end
    ratings_of_item.map(&:score).sum / ratings_of_item.count
  end

  def rating_of_style(style)
    rating_of :style, style
  end

  def rating_of_brewery(brewery)
    rating_of :brewery, brewery
  end

  def rated_breweries
    rated :brewery
  end

  def rated_styles
    rated :style
  end
end
