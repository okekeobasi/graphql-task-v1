# frozen_string_literal: true

require 'rails_helper'

module Queries
  # Test Calculate Price Query using RSpec
  RSpec.describe 'CalculatePrice', type: :request do
    describe 'POST' do
      # Is connection to coindesk API sucessful?
      it 'fetches the bitcoin rate from Coindesk' do
        exchange_rate = 'NGN'
        # Call the Coindesk service
        bitcoin_price = Coindesk.get_bitcoin_price(exchange_rate)
        # Is the value returned a float, if not fail
        expect(bitcoin_price.is_a?(Float)).to be true
      end

      # Can we use the value fetched to calculate price
      it 'can calculate bitcoin price in NGN' do
        exchange_rate = 'NGN'
        # Call the coindesk service
        bitcoin_price = Coindesk.get_bitcoin_price(exchange_rate)
        margin = 0.2

        # Send the Arguments to the GraphQL endpoint
        post '/graphql', params: {
          query: query(type: 'buy', margin: margin, exchange_rate: exchange_rate)
        }

        # Parse the response
        json = JSON.parse(response.body)

        # Is the response similar to this, if not fail
        expect(json).to include(
          'data' => { 'calculatePrice' => bitcoin_price + (margin / 100) }
        )
      end
    end

    # This is the RootQuery
    def query(type:, margin:, exchange_rate:)
      # How our Query Looks on GraphiQL
      <<~GQL
        {
          calculatePrice(
            type: #{type},
            margin: #{margin},
            exchangeRate: #{exchange_rate}
          )
        }
      GQL
    end
  end
end
