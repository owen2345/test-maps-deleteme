# frozen_string_literal: true

class Dealer < ApplicationRecord
  validates_presence_of :name, :latitude, :longitude
  validates_uniqueness_of :name
end
