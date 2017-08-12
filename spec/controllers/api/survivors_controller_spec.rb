require 'rails_helper'

RSpec.describe Api::SurvivorsController, type: :controller do
  describe 'POST #create' do
    context 'when there are no errors in the request params' do
      let(:survivor_attr) { FactoryGirl.attributes_for :survivor }

      before { post :create, params: {survivor: survivor_attr} }

      it { expect(response).to have_http_status(:created) }
      it { expect(json_response).to have_key(:data)}
      it { expect(json_data_member).to include(:id, :type, :attributes) }

      it "should return a response with the object representation" do
        expect(json_data_member[:attributes][:name]).to eq(survivor_attr[:name])
      end

      it 'should return the items association as an inventory attribute' do
        expect(json_data_member[:attributes]).to include(:inventory)
      end
    end

    context 'when the request has errors' do
      let(:survivor_attr) { FactoryGirl.attributes_for :survivor, name: "" }

      before { post :create, params: {survivor: survivor_attr} }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(json_response).to have_key(:errors)}

      it "should return a response with the error explanation" do
        expect(json_errors_member[:name]).to include("can't be blank")
      end
    end
  end
end
