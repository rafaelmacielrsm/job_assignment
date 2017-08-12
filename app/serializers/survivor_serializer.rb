class SurvivorSerializer < ActiveModel::Serializer
  attributes :id, :name, :age, :gender, :latitude, :longitude, :inventory
  # has_many :items, serializer: ItemSerializer

  def inventory
    object.items.collect { |item|
      [Survivor.enum_items.key(item.item_id), item.quantity]
    }.to_h
  end
end
