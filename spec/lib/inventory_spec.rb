require "rails_helper"

RSpec.describe Inventory do
  subject{ Inventory }

  it { expect(subject).to respond_to(:items_and_values) }
  it { expect(subject).to respond_to(:lookup) }
  it { expect(subject).to respond_to(:evaluate_items) }

  describe '.items_and_values' do
    it { expect(subject.items_and_values).to be_an(HashWithIndifferentAccess) }
  end

  describe '.lookup' do
    context "when the arg is a valid item identifier" do
      it 'should return the items name' do
        expect(subject.lookup(1)).to eq 'water'
      end
    end

    context "when the arg is an invalid item identifier" do
      it 'should return nil' do
        expect(subject.lookup(99)).to be_nil
      end
    end
  end

  describe '.evaluate_items' do
    let(:items) { {
      "water" => 2, "food" => 4, "medication" => 1, "ammunition" => 2
      } }
    it 'should return the sum of values of all items in args' do
      expect(subject.evaluate_items(items)).to eq(24)
    end
  end
end
