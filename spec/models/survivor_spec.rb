require 'rails_helper'

RSpec.describe Survivor, type: :model do
  subject { FactoryGirl.create :survivor }

  it { expect( subject ).to respond_to(:name) }
  it { expect( subject ).to respond_to(:age) }
  it { expect( subject ).to respond_to(:gender) }
  it { expect( subject ).to respond_to(:longitude) }
  it { expect( subject ).to respond_to(:latitude) }
  it { expect( subject ).to respond_to(:items) }
  it { expect( subject ).to respond_to(:inventory) }
  it { expect( Survivor ).to respond_to(:infected_survivors) }
  it { expect( Survivor ).to respond_to(:non_infected_survivors) }

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

  describe 'associations' do
    it {expect(subject).to have_many(:items)}
  end

# Defined method
  describe '#last_location' do
    let(:coord_array) { [subject.latitude, subject.longitude] }

    it { expect( subject ).to respond_to :last_location }

    it "should return an array containing latitude and longitude" do
      expect(subject.last_location).to eq(coord_array)
    end
  end

  describe '#update_location!' do
    let(:new_latitude) { FFaker::Geolocation.lat.to_s }
    let(:new_longitude) { FFaker::Geolocation.lng.to_s }
    let(:coord_array) { [new_latitude, new_longitude] }

    it { expect{subject.update_location!(coord_array)}.
      to change(subject, :latitude).and change(subject, :longitude)}
  end
end
