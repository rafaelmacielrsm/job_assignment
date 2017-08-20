require 'rails_helper'
require 'support/trade_helper'

RSpec.configure do |c|
  c.include TradeHelper
end

RSpec.describe Item, type: :model do
  it { expect(subject).to respond_to(:survivor) }
  it { expect(subject).to respond_to(:item_id) }
  it { expect(subject).to respond_to(:quantity) }
  it { expect(Item).to respond_to(:items_average_for_non_infected_survivors) }

  describe "validations" do
    it { expect(subject).to validate_presence_of(:survivor) }
    it { expect(subject).to validate_presence_of(:item_id) }
    it { expect(subject).to validate_presence_of(:quantity) }
    it { expect(subject).to validate_numericality_of(:quantity).
      is_greater_than_or_equal_to(0)}
  end

  describe 'associations' do
    it { expect(subject).to belong_to(:survivor) }
  end

  describe '.items_average_for_non_infected_survivors' do
    let(:survivor_1) { FactoryGirl.create :survivor }
    let(:survivor_2) { FactoryGirl.create :survivor }
    let(:inventory_1) {{water: 3, food: 4, medication: 5, ammunition: 6}}
    let(:inventory_2) {{water: 1, food: 2, medication: 3, ammunition: 4}}

    before do
      create_items(survivor_1, inventory_1)
      create_items(survivor_2, inventory_2)
    end

    it 'should return the average for the non infected survivor' do
      expect(Item.items_average_for_non_infected_survivors.values).
        to eq [2,3,4,5]
    end

    it 'should change the average when a survivor is flagged as infected' do
      expect{ survivor_2.update_attributes(infected: true) }.to change{
      Item.items_average_for_non_infected_survivors.values }.to([3,4,5,6])
    end
  end

  describe '.points_lost_due_to_infection' do
    let(:survivor_1) { FactoryGirl.create :survivor }
    let(:survivor_2) { FactoryGirl.create :survivor }
    let(:inventory_1) {{water: 3, food: 4, medication: 5, ammunition: 6}}
    let(:inventory_2) {{water: 1, food: 2, medication: 3, ammunition: 4}}

    before do
      create_items(survivor_1, inventory_1)
      create_items(survivor_2, inventory_2)
      survivor_2.update_attributes(infected: true)
    end

    it { expect(Item.points_lost_due_to_infection).to eq(20) }

    it 'should change the points lost when a survivor is flagged as infected' do
      expect{ survivor_1.update_attributes(infected: true) }.to change{
        Item.points_lost_due_to_infection }.from(20).to(60)
    end
  end
end
