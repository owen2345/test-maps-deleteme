# frozen_string_literal: true

FactoryBot.define do
  factory :api_dealer_data, class: Hash do
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.phone_number }
    addresses { [] }
    transient do
      qty_address { 2 }
    end

    after(:build) do |data, ev|
      data['addresses'] = build_list(:api_dealer_address_data, ev.qty_address) if ev.qty_address
    end

    initialize_with { attributes.stringify_keys }
  end

  factory :api_dealer_address_data, class: Hash do
    street { Faker::Name.name }
    city { Faker::Name.name }
    zipcode { Faker::Address.zip_code }
    country { Faker::Name.name }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    initialize_with { attributes.stringify_keys }
  end
end
