require 'rails_helper'

RSpec.describe Api::InfectionReportsController, type: :controller do
  let(:survivor_1) { FactoryGirl.create :survivor }
  let(:survivor_2) { FactoryGirl.create :survivor }

  before { set_default_headers }

  describe 'POST #create' do
    context 'when all params are correct' do
      let(:params_hash) do
        { survivor_id: survivor_1.id,
          infection_report: { infected_id: survivor_2.id} }
        end

        before { post :create, params: params_hash }

        it { expect(response).to have_http_status :created }
        it { expect(json_response).to have_key(:data) }
        it { expect(json_data_member).to include(:id, :type, :relationships) }
    end

    context 'when the request has errors' do
      let(:params_hash) do {
            survivor_id: survivor_1.id,
            infection_report: { infected_id: survivor_1.id}}
      end

      before { post :create, params: params_hash }

      it { expect(response).to have_http_status :unprocessable_entity }
      it { expect(json_response).to have_key(:errors) }

      it "should return a response with the error explanation" do
        expect(json_errors_member[:infected_id].first).
          to include("can't flag yourself")
      end
    end

    context "when a survivor is reported three times" do
      let(:create_request) do
        post :create, params: {
            survivor_id: survivor_2.id,
            infection_report: { infected_id: survivor_1.id}
        }
      end

      before do
        2.times do
          FactoryGirl.create :infection_report, reported_survivor: survivor_1
        end
      end

      it 'should change the the survivor infected status' do
        expect{ create_request }.to change{survivor_1.reload.infected}.to(true)
      end
    end
  end
end
