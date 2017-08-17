module TradeHelper
  # create_items, create a items for the survivor
  # => Encapsulates the inventory creating process
  # Args:
  # => survivor: A Survivor Object
  # => inventory: The hash with items or empty
  # => eg.: { water: 3, food: 9, medication: 7, ammunition: 3}
  def create_items(survivor, inventory)
    Inventory.items_and_values.each do |name, info|
      if inventory.include?(name) || inventory.include?(name.to_sym)
        survivor.items.create(item_id: info[:id],
          quantity: inventory[name.to_sym])
      else
        survivor.items.create(item_id: info[:id], quantity: 0)
      end
    end
  end

  def build_trade_hash(from_id, from_items_hash, to_id, to_items_items)
    {
      trade: {
        offer: {survivor_id: from_id, items: from_items_hash },
        for:  {survivor_id: to_id, items: to_items_items }
      }
    }
  end
end
