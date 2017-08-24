class InventoryValidator < ActiveModel::Validator
  def validate(record)
    items_errors = []
    record.items.each do |item|
      next if item.valid?
      item.errors.full_messages.each do |msg|
        items_errors << [item.item_name.to_sym, "#{msg}"]
      end
    end
    unless record.errors[:items].empty?
      record.errors.delete(:items)
      record.errors.add(:items, items_errors.to_h)
    end
  end
end
