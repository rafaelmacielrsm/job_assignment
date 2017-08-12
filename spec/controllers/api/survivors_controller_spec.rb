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

  describe 'PUT/PATCH #update' do
    let(:survivor) { FactoryGirl.create(:survivor) }

    context 'when the location is valid' do
      let(:new_location) { {
        latitude: FFaker::Geolocation.lat.to_s,
        longitude: FFaker::Geolocation.lng.to_s } }

      before {patch :update, params: {id: survivor.id, survivor: new_location} }

      it { expect(response).to have_http_status(:ok) }
      it { expect(json_response).to have_key(:data)}

      it "should change the latitude value" do
        expect(json_data_attr[:latitude]).to eq(new_location[:latitude])
      end

      it "should change the longitude value" do
        expect(json_data_attr[:longitude]).to eq(new_location[:longitude])
      end
    end

    context 'when the location is invalid' do
      let(:new_location) { {latitude: "200", longitude: "200"} }

      before {patch :update, params: {id: survivor.id, survivor: new_location} }

      it { expect(response).to have_http_status :unprocessable_entity }
      it { expect(json_response).to have_key(:errors)}

      it 'should return a json with the error explanation' do
        expect(json_errors_member[:latitude].first).to include("less than")
      end

    end
  end
end
