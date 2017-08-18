require 'rails_helper'
require 'support/trade_helper'

RSpec.configure do |c|
  c.include TradeHelper
end

RSpec.describe Api::TradesController, type: :controller do
  before { set_default_headers }

  describe 'POST #create' do
    let(:inventory_1) {{water: 3, food: 2, medication: 3, ammunition: 2}}
    let(:inventory_2) {{water: 3, food: 9, medication: 7, ammunition: 3}}
    let(:survivor_1) { FactoryGirl.create :survivor }
    let(:survivor_2) { FactoryGirl.create :survivor }

    context 'when everything if correct' do
      before do
        create_items( survivor_1, inventory_1 )
        create_items( survivor_2, inventory_2 )

        post :create, params: { trade: {
          offer: {survivor_id: survivor_1.id, items: {water: 2} },
          for:  {survivor_id: survivor_2.id, items: {medication: 4}}
            } }
      end

      it { expect(response).to have_http_status(:created) }

      it 'should return the record json of the survivor who started the trade' do
        expect(json_data_member[:type]).to eq "survivors"
      end

      it "should change the items quantity based on the trade" do
        expect(survivor_1.items.pluck(:quantity)).to match_array([1,2,7,2])
      end

      it "should change the items quantity for the other survivor" do
        expect(survivor_2.items.pluck(:quantity)).to match_array([5,9,3,3])
      end
    end

    context 'when the trade offer has errors' do
      before do
        create_items( survivor_1, inventory_1 )
        create_items( survivor_2, inventory_2 )

        post :create, params: { trade: {
          offer: {survivor_id: survivor_1.id, items: {water: 2} },
          for:  {survivor_id: survivor_2.id, items: {medication: 2}}
            } }
      end

      it { expect(response).to have_http_status :unprocessable_entity }

      it 'should return information about the error' do
        expect(json_errors_member.to_s).to include("not worth the same")
      end
    end
  end
end
