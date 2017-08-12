FactoryGirl.define do
  factory :survivor do
    name { FFaker::Name.name }
    age Random.rand(10..80)
    gender { FFaker::Identification.gender }
    longitude { FFaker::Geolocation.lng.to_s }
    latitude { FFaker::Geolocation.lat.to_s }
    infected false
  end
end
