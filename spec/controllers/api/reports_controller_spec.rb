require 'rails_helper'
require 'support/trade_helper'

RSpec.configure do |c|
  c.include TradeHelper
end

RSpec.describe Api::ReportsController, type: :controller do
  let(:survivor_1) { FactoryGirl.create :survivor }
  let(:survivor_2) { FactoryGirl.create :survivor }
  let(:survivor_3) { FactoryGirl.create :survivor }

  let(:inventory_1) {{water: 1, food: 1, medication: 1, ammunition: 1}}
  let(:inventory_2) {{water: 3, food: 3, medication: 3, ammunition: 3}}
  let(:inventory_3) {{water: 5, food: 5, medication: 5, ammunition: 5}}

  before { set_default_headers }

  describe 'GET #index' do
    before{ get :index }

    it { expect(response).to have_http_status(:ok) }

    it 'should return a data json with null value' do
      expect(json_data_member).to eq "null"
    end

    it 'should contain a links top level member' do
      expect(json_response).to include(:links)
    end

    it 'should contains links for the reports' do
      expect(json_response[:links]).to all( include("http") )
    end
  end

  describe 'GET #infected' do
    context 'when there are registered survivors' do
      before do
        4.times{ FactoryGirl.create :survivor }
        FactoryGirl.create :survivor, infected: true
        get :infected
      end

      it { expect(response).to have_http_status(:ok) }

      it 'should return a json with the percentage value' do
        expect(json_data_member[:report][:value]).to eq 0.2
      end
    end

    context 'when there are no survivors registered' do
      before { get :infected }

      it { expect(response).to have_http_status(:ok) }

      it 'should return an error message' do
        expect(json_errors_member[:infected]).to include
          "No survivors registered"
      end
    end
  end

  describe 'GET #non_infected' do
    context 'when there are registered survivors' do
      before do
        4.times{ FactoryGirl.create :survivor }
        FactoryGirl.create :survivor, infected: true
        get :non_infected
      end
      it { expect(response).to have_http_status(:ok) }

      it 'should return a json with the percentage value' do
        expect(json_data_member[:report][:value]).to eq 0.8
      end
    end

    context 'when there are no survivors registered' do
      before { get :non_infected }

      it { expect(response).to have_http_status(:ok) }

      it 'should return an error message' do
        expect(json_errors_member[:non_infected]).to include
          "No survivors registered"
      end
    end
  end

  describe 'GET #inventory_overview' do
    before do
      create_items(survivor_1, inventory_1)
      create_items(survivor_2, inventory_2)
      create_items(survivor_3, inventory_3)

      get :inventories_overview
    end

    it { expect(response).to have_http_status(:ok) }

    it 'should return a json with every type of item' do
      expect(json_data_member[:report][:value]).to include(:water, :food,
        :medication, :ammunition)
    end

    it 'should return the values with the average for every type item' do
      expect(json_data_member[:report][:value].values()).
        to eq [3.0, 3.0, 3.0, 3.0]
    end
  end

  describe 'GET #resources_lost' do
    before do
      create_items(survivor_1, inventory_1)
      survivor_1.update_attributes(infected: true)

      get :resources_lost
    end

    it { expect(response).to have_http_status(:ok)  }

    it "should return the values in points of items from infected survivors" do
      expect(json_data_member[:report][:value]).to eq(10)
    end
  end
end
