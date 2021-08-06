# frozen_string_literal: true
ENV.each { |k, v| env(k, v) }
require 'active_support/all'

every 1.day, at: '0:30 am' do
  runner 'SyncDealers.call'
end

# INFO: just for testing
every 1.minutes do
  runner 'SyncDealers.call'
end
