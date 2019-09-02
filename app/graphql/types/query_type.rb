# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # CalculatePrice Field will return a float value
    field :calculate_price, Float, null: false do
      # Required Arguments Type, Margin, Exchange Rate
      argument :type, String, required: true
      argument :margin, Float, required: true
      argument :exchange_rate, String, required: true
    end

    # Calculate Price method
    def calculate_price(type:, margin:, exchange_rate:)
      # Get the current price of bitcoin
      bitcoin_rate = Coindesk.get_bitcoin_price(exchange_rate)

      # Calculate the margin percentage
      margin_percentage = margin / 100

      if type == 'sell'
        bitcoin_rate - margin_percentage
      elsif type == 'buy'
        bitcoin_rate + margin_percentage
      else
        # Throw a GraphQL error
        GraphQL::ExecutionError.new('Type must be either Buy or Sell')
      end
    end
  end
end
