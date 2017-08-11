require 'rails_helper'

RSpec.describe Survivor, type: :model do
  subject { FactoryGirl.create :survivor }

  it { expect( subject ).to respond_to(:name) }
  it { expect( subject ).to respond_to(:age) }
  it { expect( subject ).to respond_to(:gender) }
  it { expect( subject ).to respond_to(:longitude) }
  it { expect( subject ).to respond_to(:latitude) }

  describe '#last_location' do
    let(:coord_array) { [subject.latitude, subject.longitude] }

    it { expect( subject ).to respond_to :last_location }

    it "should return an array containing latitude and longitude" do
      expect(subject.last_location).to eq(coord_array)
    end
  end

  describe 'validations' do
    it{ expect(subject).to validate_presence_of :name }
    it{ expect(subject).to validate_presence_of :age }
    it{ expect(subject).to validate_numericality_of(:age).
      is_greater_than_or_equal_to(0) }
    it{ expect(subject).to validate_presence_of :gender }
    it{ expect(subject).to validate_presence_of :latitude }
    it{ expect(subject).to validate_numericality_of(:latitude).
      is_greater_than_or_equal_to(-90).is_less_than_or_equal_to(90)}
    it{ expect(subject).to validate_presence_of :longitude }
    it{ expect(subject).to validate_numericality_of(:longitude).
      is_greater_than_or_equal_to(-180).is_less_than_or_equal_to(180)}
  end
end
