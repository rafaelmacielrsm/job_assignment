class SurvivorSerializer < ActiveModel::Serializer
  attributes :id, :name, :age, :gender, :latitude, :longitude, :inventory

  # This method organize the items association so it is more intuitivily
  # serialized
  # The Output looks like:  { water: 0, food: 1, medication: 9, ammunition: 8 }
  def inventory
    object.items.collect { |item|
      [Inventory.lookup(item.item_id), item.quantity]
    }.to_h
  end
end
