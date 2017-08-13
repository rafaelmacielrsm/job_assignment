RSpec.shared_examples "a not findable record" do
  it { expect(response).to have_http_status(:not_found ) }

  it "should return a json containing 'null'" do
    expect(response.body).to eq("null")
  end 
end
