class Api::SurvivorsController
  # This class manager the inventory list logic
  class InventoryList
    # build_inventory method
    # => Encapsulates the inventory building process with the received parameter
    # Args:
    # => survivor: A Survivor Object
    # => inventory_hash: The hash with the params or empty
    def self.build_inventory(survivor, inventory_hash)
      Inventory.items_and_values.each do |name, info|
        if inventory_hash.include?(name)
          survivor.items.build(item_id: info[:id],
            quantity: inventory_hash[name])
        else
          survivor.items.build(item_id: info[:id], quantity: 0)
        end
      end
    end
  end
end
