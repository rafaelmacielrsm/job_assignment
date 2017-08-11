FactoryGirl.define do
  factory :survivor do
    name { FFaker::Name.name }
    age Random.rand(10..80)
    gender { FFaker::Identification.gender }
    longitude { FFaker::Geolocation.lng }
    latitude { FFaker::Geolocation.lat }
    infected false
  end
end
