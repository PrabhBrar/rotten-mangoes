class Movie < ActiveRecord::Base

  has_many :reviews

  validates :title,
    presence: true

  validates :director,
    presence: true

  validates :runtime_in_minutes,
    numericality: { only_integer: true }

  validates :description,
    presence: true

  validates :release_date,
    presence: true

  validate :release_date_is_in_the_future

  mount_uploader :image, ImageUploader

  def review_average
    reviews.sum(:rating_out_of_ten)/reviews.size
  end

  scope :search, -> (search_params) { where(Movie.search_string(search_params)) }

  def self.search_string(search_params)
    str = ""
    case search_params["duration"]
    when "Under 90 minutes"
      str = "runtime_in_minutes < 90"
    when "Between 90 and 120 minutes"
      str = "runtime_in_minutes >= 90 AND runtime_in_minutes <= 120"
    when "Over 120 minutes"
      str = "runtime_in_minutes > 120"
    end
    str += " AND " if !str.empty? && search_params.length > 1
    if search_params["keyword"]
      str += "title LIKE '%#{search_params["keyword"]}%' OR director LIKE '%#{search_params["keyword"]}%'"
    end
    str
  end

  protected

  def release_date_is_in_the_future
    if release_date.present?
      errors.add(:release_date, "should probably be in the past") if release_date > Date.today
    end
  end

end
