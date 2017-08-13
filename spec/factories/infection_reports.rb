FactoryGirl.define do
  factory :infection_report do
    survivor
    association :reported_survivor, factory: :survivor
  end
end
