require 'rails_helper'

RSpec.describe Item, type: :model do
  it { expect(subject).to respond_to(:survivor) }
  it { expect(subject).to respond_to(:item_id) }
  it { expect(subject).to respond_to(:quantity) }

  describe "validations" do
    it { expect(subject).to validate_presence_of(:survivor) }
    it { expect(subject).to validate_presence_of(:item_id) }
    it { expect(subject).to validate_presence_of(:quantity) }
    it { expect(subject).to validate_numericality_of(:quantity).
      is_greater_than_or_equal_to(0)}

    describe 'associations' do
      it { expect(subject).to belong_to(:survivor) }
    end
  end

end
