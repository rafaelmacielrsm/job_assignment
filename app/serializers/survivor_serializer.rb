class SurvivorSerializer < ActiveModel::Serializer
  attributes :id, :name, :age, :gender, :latitude, :longitude
end
