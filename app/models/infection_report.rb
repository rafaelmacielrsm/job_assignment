class InfectionReport < ApplicationRecord
  include ActiveModel::Validations
  validates_with BlockSelfReportValidator
  validates_uniqueness_of :infected_id, {
    scope: :survivor_id,
    message: "has already been reported"}

  belongs_to :survivor
  belongs_to :reported_survivor,
    class_name: "Survivor", foreign_key: 'infected_id'
end
