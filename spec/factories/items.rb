FactoryGirl.define do
  factory :item do
    survivor
    item_id { Random.rand(1..4) }
    quantity { Random.rand(1..10) }
  end
end
