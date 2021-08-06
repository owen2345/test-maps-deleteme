# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Dealer, type: :model do
  describe 'when validating' do
    %i[name latitude longitude].each do |attr|
      it "validates presence of #{attr}" do
        dealer = build(:dealer, attr => nil).tap(&:validate)
        expect(dealer.errors.key?(attr)).to be_truthy
      end
    end

    it 'validates uniqueness of name' do
      dealer = create(:dealer)
      duplicated_dealer = build(:dealer, name: dealer.name).tap(&:validate)
      expect(duplicated_dealer.errors.key?(:name)).to be_truthy
    end
  end
end
