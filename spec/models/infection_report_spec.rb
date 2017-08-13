require 'rails_helper'

RSpec.describe InfectionReport, type: :model do
  let(:survivor_1) { FactoryGirl.create :survivor }
  let(:survivor_2) { FactoryGirl.create :survivor }

  it {expect(subject).to respond_to(:survivor)}
  it {expect(subject).to respond_to(:survivor_id)}
  it {expect(subject).to respond_to(:reported_survivor)}
  it {expect(subject).to respond_to(:infected_id)}

  it 'should be invalid to self report' do
    self_report = InfectionReport.new(
      survivor: survivor_1, reported_survivor: survivor_1)
    expect(self_report).to be_invalid
  end

  it 'should prevent identical reports' do
    InfectionReport.create(survivor: survivor_1, reported_survivor: survivor_2)
    identical_report = InfectionReport.new(survivor: survivor_1,
      reported_survivor: survivor_2)
    expect(identical_report).not_to be_valid
  end

  it { expect(subject).not_to allow_value(nil).for(:survivor) }
  it { expect(subject).not_to allow_value(nil).for(:reported_survivor) }

  it { expect(subject).to belong_to :survivor }
  it { expect(subject).to belong_to :reported_survivor }
end
