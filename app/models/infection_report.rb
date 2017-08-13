class InfectionReport < ApplicationRecord
  after_create :check_reported_survivor

  include ActiveModel::Validations
  validates_with BlockSelfReportValidator
  validates_uniqueness_of :infected_id, {
    scope: :survivor_id,
    message: "has already been reported"}

  belongs_to :survivor
  belongs_to :reported_survivor,
    class_name: "Survivor", foreign_key: 'infected_id'

  def check_reported_survivor
    reported = self.reported_survivor
    unless reported.infected?
      reported.update(infected: true) if reported.reported_by.count >= 3
    end
  end
end
