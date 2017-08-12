class Survivor < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :age, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :gender, presence: true
  validates :latitude, presence: true,
    numericality: {greater_than_or_equal_to: -90, less_than_or_equal_to: 90}
  validates :longitude, presence: true,
    numericality: {greater_than_or_equal_to: -180, less_than_or_equal_to: 180}

  enum enum_items: {water: 4, food: 3, medication: 2, ammunition: 1 }

  # Associations
  has_many :items

  attr_accessor :inventory

  def inventory
    self.items
  end

  def last_location
    [self.latitude, self.longitude]
  end
end
