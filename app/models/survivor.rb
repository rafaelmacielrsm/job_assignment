class Survivor < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :age, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :gender, presence: true
  validates :latitude, presence: true,
    numericality: {greater_than_or_equal_to: -90, less_than_or_equal_to: 90}
  validates :longitude, presence: true,
    numericality: {greater_than_or_equal_to: -180, less_than_or_equal_to: 180}

  # Associations
  has_many :items

  has_many :submitted_reports, class_name: 'InfectionReport',
    foreign_key: 'survivor_id', dependent: :destroy
  has_many :reported_survivors,
    through: :submitted_reports, source: :reported_survivor

  has_many :received_reports, class_name: 'InfectionReport',
    foreign_key: "infected_id", dependent: :destroy
  has_many :reported_by, through: :received_reports, source: :survivor

  attr_accessor :inventory

  #scopes
  scope :infected_survivors, lambda { where(infected: true) }
  scope :non_infected_survivors, lambda { where(infected: false) }

  def inventory
    self.items
  end

  def last_location
    [self.latitude, self.longitude]
  end

  # update_location method
  # => Updates both latitude and longitude of a survivor
  # Args:
  # => new_location_array: Contain the latitude and longitude respectively
  def update_location!(new_location_array)
    self.update(
      latitude: new_location_array[0],
      longitude: new_location_array[1])
  end
end
