# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    # field :test_field, Integer, null: false,
    #                             description: 'An example field added by the generator'
    # def test_field
    #   'Hello World!'
    # end

    field :calculate_price, Float, null: false do
      argument :type, String, required: true
      argument :margin, Float, required: true
      argument :exchange_rate, String, required: true
    end

    def calculate_price(type:, margin:, exchange_rate:)
      if type == 'buy' or type == 'sell'
        margin
      else
        GraphQL::ExecutionError.new('Type must be either Buy or Sell')
      end
    end
  end
end
