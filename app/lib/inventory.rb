# This class deal with the inventory logic
class Inventory
  ITEM_AND_VALUES = ActiveSupport::HashWithIndifferentAccess.new({
      water: {id: 1, value: 4},
      food: {id: 2, value: 3},
      medication: {id: 3, value: 2},
      ammunition: {id: 4, value: 1} } )

  # Static method to access ITEM_AND_VALUES
  def self.items_and_values
    ITEM_AND_VALUES
  end

  # A basic lookup to find the product name
  # Args:
  #   id: item type identifier
  def self.lookup(id)
    ITEM_AND_VALUES.select {|k,v| v[:id] == id}.keys.first
  end

  def self.evaluate_items(items)
    items.map{ |k,v| Inventory.items_and_values[k][:value] * v || 0 }.reduce(:+)
  end
end
