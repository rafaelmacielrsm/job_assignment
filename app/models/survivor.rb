class Survivor < ApplicationRecord
  # Associations
  has_many :items
  # accepts_nested_attributes_for :items
  has_many :submitted_reports, class_name: 'InfectionReport',
  foreign_key: 'survivor_id', dependent: :destroy
  has_many :reported_survivors,
  through: :submitted_reports, source: :reported_survivor

  has_many :received_reports, class_name: 'InfectionReport',
  foreign_key: "infected_id", dependent: :destroy
  has_many :reported_by, through: :received_reports, source: :survivor

  # Validations
  validates :name, presence: true
  validates :age, presence: true, numericality: {greater_than_or_equal_to: 0,
    only_integer: true}
  validates :gender, presence: true
  validates :latitude, presence: true,
    numericality: {greater_than_or_equal_to: -90, less_than_or_equal_to: 90}
  validates :longitude, presence: true,
    numericality: {greater_than_or_equal_to: -180, less_than_or_equal_to: 180}

  include ActiveModel::Validations
   validates_with InventoryValidator, on: :create
  # #TODO: Create a custom validator for this logic
  # validate :items, on: :create do |survivor|
  #   items_errors = []
  #   survivor.items.each do |item|
  #     next if item.valid?
  #     item.errors.full_messages.each do |msg|
  #       items_errors << [item.item_name.to_sym, "#{msg}"]
  #     end
  #   end
  #   unless errors[:items].empty?
  #     errors.delete(:items)
  #     errors.add(:items, items_errors.to_h)
  #   end
  # end


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
