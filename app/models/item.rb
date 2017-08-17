class Item < ApplicationRecord
  belongs_to :survivor

  validates :survivor, presence: true
  validates :item_id, presence: true
  validates :quantity,
    presence: true,
    numericality: { greater_than_or_equal_to: 0 }

  def item_name
    Inventory.lookup(self.item_id)
  end
end
