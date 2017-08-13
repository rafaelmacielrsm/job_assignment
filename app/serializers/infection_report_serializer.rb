class InfectionReportSerializer < ActiveModel::Serializer
  attributes :id
  has_one :survivor
  belongs_to :infected_survivor, {class_name: 'Survivor', foreign_key: 'infected_id'}
end
