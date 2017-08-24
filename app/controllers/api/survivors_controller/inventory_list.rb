class Api::SurvivorsController
  # This class manages the inventory list logic
  # this approach follows namespacing suggestion as in the blog article:
  # http://vrybas.github.io/blog/2014/08/15/a-way-to-organize-poros-in-rails/
  # But many different approaches would work as well, like 'UseCase' or 'Services'
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
