module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return 0 if ratings.empty?
    ratings.map(&:score).sum.to_f/ratings.count
  end
end