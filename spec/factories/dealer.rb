# frozen_string_literal: true

FactoryBot.define do
  factory :dealer do
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.phone_number }
    street { Faker::Name.name }
    city { Faker::Name.name }
    zipcode { Faker::Address.zip_code }
    country { Faker::Name.name }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end