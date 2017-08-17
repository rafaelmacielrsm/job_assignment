class Api::TradesController
  # This class deals with the trading logic

  class Trading
    attr_accessor :errors

    # initialize
    # => Args:
    # => trade_params: hash with the info required to the trade process
    # eg.:   {  offer: {survivor_id: 1, items: {water: 2} },
    #           for:  { survivor_id: 2, items: {medication: 4} } }
    def initialize(trade_params)
      @offer = trade_params[:offer]
      @for = trade_params[:for]
      @errors = {}
    end
    # valid?
    # Check if every condition is met to ensure the trade integrity
    # obs.: The validate_record is short-circuited
    def valid?
      validate_survivors and validate_items && validate_records
    end

    # execute_trade!
    # Does the transfer inside a transaction
    def execute_trade!
      offer_inventory = @offer[:records].map{ |e| [e.item_name.to_sym, e]}.to_h
      for_inventory = @for[:records].map{ |e| [e.item_name.to_sym, e]}.to_h

      @offer[:items].each do |name, quantity|
        offer_inventory[name.to_sym].quantity -= quantity
        for_inventory[name.to_sym].quantity += quantity
      end

      @for[:items].each do |name, quantity|
        for_inventory[name.to_sym].quantity -= quantity
        offer_inventory[name.to_sym].quantity += quantity
      end

      ActiveRecord::Base.transaction do
        @offer[:records].each(&:save)
        @for[:records].each(&:save)
      end
    end

    #.to_a validate_survivors
    # Call all methods to ensure the integrity of the info used in the trading
    def validate_survivors
      not(same_survivor? or invalid_survivors?) ? true : false
    end

    # validate_items
    # Call all methods to ensure the integrity of the info used in the trading
    def validate_items
      not(empty_item_list? or has_invalid_items? or
        has_different_point_values?) ? true : false
    end

    # validate_records
    # => Ensure the survivors can fulfill the deal
    def validate_records
      have_enough_items_to_trade?
    end

    private
    # same_survivor?
    # Ensure that both 'offer' and 'for' aren't the same survivor
    def same_survivor?
      if @offer[:survivor_id] == @for[:survivor_id]
        add_error(:for, :survivor_id, "not allowed to trade with self")
        return true
      end

      return false
    end

    # invalid_survivors?
    # Ensure that every part involved in the trading process does exist
    def invalid_survivors?
      unless Survivor.where(id: @offer[:survivor_id]).exists?
        add_error(:offer, :survivor_id, "Survivor does not exist")
        error = true
      end

      unless Survivor.where(id: @for[:survivor_id]).exists?
        add_error(:for, :survivor_id, "Survivor does not exist")
        error = true
      end

      error ||= false
    end

    # empty_item_list?
    # This method make sure there aren't empty lists
    def empty_item_list?
      if @offer[:items] && @offer[:items].empty?
        error = true
        add_error(:offer, :items, "Empty item-list is not allowed")
      end

      if @for[:items] && @for[:items].empty?
        error = true
        add_error(:for, :items, "Empty item-list is not allowed")
      end

      error ||= false
    end

    # has_invalid_items?
    # Check if any of survivor is asking for an invalid item in the deal
    def has_invalid_items?
      unless @offer[:items].empty? || @offer[:items].select { |item_name|
        !Inventory.items_and_values.include?(item_name)}.empty?
        add_error(:offer, :items, "There is an invalid item in the list")
        error = true
      end
      unless @for[:items].empty? || @for[:items].select { |item_name|
        !Inventory.items_and_values.include?(item_name)}.empty?
        add_error(:for, :items, "There is an invalid item in the list")
        error = true
      end

      error ||= false
    end

    # fetch_inventory
    # Query the db to get the items for each survivor involved in the trade
    def fetch_inventory
      @offer[:records] ||= Item.where(survivor_id: @offer[:survivor_id]).to_a
      @for[:records] ||= Item.where(survivor_id: @for[:survivor_id]).to_a
    end

    # have_enough_items_to_trade?
    # Check if each survivor has enough items to fulfill the deal
    # A database query is needed to check, this method already fetch those Items
    def have_enough_items_to_trade?
      fetch_inventory

      is_valid = true

      max_avaliable_quantity = @offer[:records].map {|x|
        [x.item_name.to_sym ,x.quantity]}.to_h

      @offer[:items].each do |item, quantity|
        if quantity > max_avaliable_quantity[item]
          is_valid = false
          add_error(:offer, :items, {item.to_sym =>
            "Not enough items, only #{max_avaliable_quantity[item]} available"})
        end
      end

      max_avaliable_quantity = @for[:records].map {|x|
        [x.item_name.to_sym ,x.quantity]}.to_h

      @for[:items].each do |item, quantity|
        if quantity > max_avaliable_quantity[item]
          is_valid = false
          add_error(:for, :items, {item.to_sym =>
            "Not enough items, only #{max_avaliable_quantity[item]} available"})
        end
      end
      is_valid
    end

    # has_different_point_values
    # Check for incompatible point values
    def has_different_point_values?
      offer_value = Inventory.evaluate_items(@offer[:items])
      for_value = Inventory.evaluate_items(@for[:items])
      if offer_value != for_value
        add_error(:for, :items,
          "Invalid Offer, the items are not worth the same")
        true
      else false; end
    end

    # add_errors
    # => args:
    # => part: the symbol for the survivor (:offer or :for)
    # => attribute: the symbol to identify the error (:survivor_id or :items)
    # => message: the shown error message
    def add_error(part, attribute, message)
      @errors[part] ||= {}
      @errors[part][attribute] ||= []
      @errors[part][attribute] << message
    end
  end
end
