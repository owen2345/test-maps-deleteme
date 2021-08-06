# frozen_string_literal:true

require 'open-uri'
class SyncDealers < ApplicationService
  API_URI = 'https://fakerapi.it/api/v1/companies?_seed=1&_quantity=100'

  def call
    load_dealers
    remove_missing_dealers
  end

  # TODO: Add pagination for large data
  # TODO: What happens with failed dealers?
  # INFO: For current requirement only the first address is required
  def load_dealers
    fetch_dealers.each do |row|
      data = parse_dealer_data(row)
      dealer = Dealer.where(name: data['name']).first_or_initialize
      dealer.attributes = data
      log("dealer import failed: #{dealer.errors.full_messages.join(', ')}") unless dealer.save
    end
  end

  def parse_dealer_data(row)
    first_address = row['addresses'].first || {}
    first_address = first_address.slice('street', 'city', 'zipcode', 'latitude', 'longitude')
    row.slice('name', 'phone').merge(first_address)
  end

  def remove_missing_dealers
    names = fetch_dealers.map { |row| row['name'] }
    Dealer.where.not(name: names).delete_all
  end

  # @return [Array<Hash>]
  # @option [String] :name
  # @option [String] :phone
  # @option addresses [Array<Hash>]
  #     @option [String] :street
  #     @option [String] :city
  #     @option [String] :zipcode
  #     @option [String] :country
  #     @option [Float] :latitude
  #     @option [Float] :longitude
  def fetch_dealers
    @fetch_dealers ||= JSON.load(open(API_URI))['data']
  end
end
