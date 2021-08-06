# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Api::DealersController, type: :controller do
  let!(:dealer) { create(:dealer) }
  let(:parsed_body) { JSON.parse(response.body) }

  describe '#index' do
    it 'returns items with expected attributes' do
      get :index
      expected_data = dealer.as_json(only: %i[id name latitude longitude])
      expect(parsed_body.first).to eq(expected_data)
    end

    it 'returns paginated items' do
      per_page = 10
      expect_pagination(per_page)
      get :index, params: { per_page: per_page }
    end

    it 'excludes non required attributes' do
      get :index
      expect(parsed_body.first).to match(hash_excluding('phone' => dealer.phone))
    end
  end

  describe '#show' do
    it 'returns corresponding dealer info' do
      get :show, params: { id: dealer.id }
      expect(parsed_body['id']).to eq(dealer.id)
    end

    it 'returns "Dealer not found" when not found' do
      get :show, params: { id: -11 }
      expect(parsed_body['error']).to eq('Dealer not found')
    end
  end

  def expect_pagination(per_page)
    mock_pagination = double(per: [])
    allow(Dealer).to receive(:page).and_return(mock_pagination)
    expect(mock_pagination).to receive(:per).with(per_page.to_s)
  end
end
