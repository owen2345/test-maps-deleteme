# frozen_string_literal: true

require 'rails_helper'
RSpec.describe SyncDealers do

  let(:inst) { described_class.new }
  let!(:dealers_data) { build_list(:api_dealer_data, 1) }
  let(:dealer_data) { dealers_data.first }
  before { mock_dealers_data(dealers_data) }

  describe 'when valid data' do
    it 'registers the corresponding dealer' do
      expect { inst.call }.to change(Dealer, :count)
    end

    it 'updates the corresponding dealer if already registered' do
      existent_dealer = create(:dealer, name: dealer_data['name'], phone: '00-00000')
      inst.call
      expect(existent_dealer.reload.phone).to eq(dealer_data['phone'])
    end

    it 'destroys dealers that are no longer in the api' do
      dealer = create(:dealer, name: 'dealer not in dealers_data')
      inst.call
      expect { dealer.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'when invalid data' do
    it 'prints error messages when name is empty' do
      dealers_data.first['name'] = nil
      mock_dealers_data(dealers_data)
      expect(inst).to receive(:log).with(include('dealer import failed'))
      inst.call
    end

    it 'prints error message when no addresses' do
      dealers_data.first['addresses'] = []
      mock_dealers_data(dealers_data)
      expect(inst).to receive(:log).with(include('dealer import failed'))
      inst.call
    end

    it 'does not register failed dealers' do
      dealers_data.first['addresses'] = []
      mock_dealers_data(dealers_data)
      expect { inst.call }.not_to change(Dealer, :count)
    end
  end

  def mock_dealers_data(data)
    allow(inst).to receive(:fetch_dealers).and_return(data)
  end
end
