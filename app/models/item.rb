class Item < ApplicationRecord
  belongs_to :survivor

  validates :survivor, presence: true
  validates :item_id, presence: true
  validates :quantity,
    presence: true,
    numericality: { greater_than_or_equal_to: 0 }

  # this scope return an array containing the sum of quantity of items of all
  # survivor depending on the arg provided
  # eg.: [<Item item_id: 1, sum: 200>, <Item ...> , <Item item_id: 4, sum: 154>]
  scope :total_per_item_depending_on_status, lambda { |is_infected = false|
    joins(:survivor)
    .where(["survivors.infected = ?", is_infected])
    .select("sum(quantity) as sum, items.item_id")
    .group(:item_id)
  }

  def item_name
    Inventory.lookup(self.item_id)
  end

  # This class method call the scope and mount a hash with the name and the
  # average per item
  def self.items_average_for_non_infected_survivors
    non_infected = Survivor.non_infected_survivors.count.to_f

    return nil if non_infected == 0

    self.total_per_item_depending_on_status.map {
      |e| [e.item_name, (e.sum/non_infected).round(2)] }.to_h
  end

  # This class method gether the items for all survivor flagged as infected then
  # Evaluate the total point value for every type of item.
  def self.points_lost_due_to_infection
  Inventory.evaluate_items(self.total_per_item_depending_on_status(
    is_infected = true).map {|e| [e.item_name, e.sum] }.to_h)
  end
end
