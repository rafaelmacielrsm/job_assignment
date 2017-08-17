require "rails_helper"

require 'support/trade_helper'

RSpec.configure do |c|
  c.include TradeHelper
end

RSpec.describe Api::TradesController::Trading do
  subject { Api::TradesController::Trading }
  let(:survivor_1) { FactoryGirl.create :survivor }
  let(:survivor_2) { FactoryGirl.create :survivor }
  let(:trading) { subject.new(params[:trade]) }

  it { expect(subject.new({})).to respond_to(:errors) }

  describe '.initialize' do
    it { expect(subject.new({})).to be_an(Api::TradesController::Trading) }
  end

  describe '#validate_survivors' do
    context 'when the parts involved are valid survivors' do
      let(:params) { build_trade_hash(survivor_1.id, {}, survivor_2.id, {}) }

      it { expect(trading.validate_survivors).to be true }
    end

    context 'when the parts involved are the same survivor' do
      let(:params) { build_trade_hash(survivor_1.id, {}, survivor_1.id, {}) }

      it { expect(trading.validate_survivors).to be false }

      it "should add an entry in the errors hash" do
        trading.validate_survivors
        expect(trading.errors.to_s).to include("not allowed to trade")
      end
    end

    context 'when at least one part involved does not exist' do
      let!(:params) {
        build_trade_hash(survivor_1.id + 9, {}, survivor_2.id + 1, {}) }

      it { expect(trading.validate_survivors).to be false }

      it "should add entries in the errors hash" do
        trading.validate_survivors
        expect(trading.errors.to_s).to include("Survivor does not exist")
      end
    end
  end

  describe '#validate_items' do

    context 'when receiving valid item names ' do
      let(:params) { build_trade_hash(survivor_1.id, {water: 1},
        survivor_2.id, {medication: 2}) }

      it { expect(trading.validate_items).to be true }
    end

    context 'when receiving an empty item list' do
      let(:params) { build_trade_hash(survivor_1.id, {}, survivor_2.id, {}) }

      it{ expect(trading.validate_items).to be false }

      it 'should add an entry in the errors hash' do
        trading.validate_items
        expect(trading.errors.to_s).to include("Empty item-list")
      end
    end

    context 'when the item list has an invalid item name' do
      let(:params) { build_trade_hash(survivor_1.id, {water: 1},
        survivor_2.id, {wanter: 1}) }

      it{ expect(trading.validate_items).to be false }

      it 'should add an entry in the errors hash' do
        trading.validate_items
        expect(trading.errors.to_s).to include("invalid item")
      end
    end

    context 'when the trade offer has incompatible values' do
      let(:params) { build_trade_hash(survivor_1.id, {water: 1},
        survivor_2.id, {food: 1}) }

      it { expect(trading.validate_items).to be false }

      it 'should add an entry in the errors hash' do
        trading.validate_items
        expect(trading.errors.to_s).to include("not worth the same")
      end
    end
  end

  describe '#validate_records' do
    let(:inventory_1) {{water: 3, food: 2, medication: 3, ammunition: 2}}
    let(:inventory_2) {{water: 3, food: 9, medication: 7, ammunition: 3}}

    before do
      create_items(survivor_1, inventory_1)
      create_items(survivor_2, inventory_2)
    end

    context "when the items and quantity are valid" do
      let(:params) { build_trade_hash(survivor_1.id, {water: 1},
      survivor_2.id, {medication: 2}) }

      it { expect(trading.validate_records).to be true }
    end

    context "when the quantity to be traded is less than total" do
      let(:params) { build_trade_hash(survivor_1.id, {water: 4},
      survivor_2.id, {medication: 8}) }

      it { expect(trading.validate_records).to be false }

      it 'should add an entry in the errors hash' do
        trading.validate_records
        expect(trading.errors.to_s).to include("water", "medication")
      end
    end
  end

  describe '#valid?' do
    let(:inventory_1) {{water: 3, food: 2, medication: 3, ammunition: 2}}
    let(:inventory_2) {{water: 3, food: 9, medication: 7, ammunition: 3}}

    before do
      create_items(survivor_1, inventory_1)
      create_items(survivor_2, inventory_2)
    end

    context 'when everything is correct' do

      let(:params) { build_trade_hash(survivor_1.id, {water: 1},
      survivor_2.id, {medication: 2}) }
      it {expect(trading.valid?).to be true}
      it "should have no entries in the error variable" do
        trading.valid?
        expect(trading.errors).to eq({})
      end
    end

    context 'when there are errors in the survivor or items' do
      let(:params) { build_trade_hash(survivor_1.id, {water: 1},
        survivor_1.id, {medication: 1}) }

      before do
        allow(trading).to receive(:validate_records)
        trading.valid?
      end

      it 'should not send a validate_records message' do
        expect(trading).not_to have_received(:validate_records)
      end
    end
  end

  describe '#execute_trade!' do
    let(:params) { build_trade_hash(survivor_1.id, {water: 1},
      survivor_2.id, {medication: 2}) }
    let(:inventory_1) {{water: 3, food: 2, medication: 3, ammunition: 2}}
    let(:inventory_2) {{medication: 7}}
    def items_array_1 ; Item.where(survivor_id: survivor_1).pluck(:quantity) end
    def items_array_2 ; Item.where(survivor_id: survivor_2).pluck(:quantity) end

    before do
      create_items(survivor_1, inventory_1)
      create_items(survivor_2, inventory_2)
      trading.valid?
    end

    it 'should change the quantities for the survivor offering a trade' do
      expect{trading.execute_trade!}.to change{ items_array_1 }.to([2,2,5,2])
    end

    it 'should change the quantities for the survivor receiving a trade' do
      expect{trading.execute_trade!}.to change{ items_array_2 }.to([1,0,5,0])
    end
  end
end
