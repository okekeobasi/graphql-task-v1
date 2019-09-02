# frozen_string_literal: true

# Coindesk API will be here
module Coindesk
  # The function to get the current price of bitcoin
  def self.get_bitcoin_price(exchange_rate)
    # Using the Faraday gem for http requests
    res = Faraday.get "https://api.coindesk.com/v1/bpi/currentprice/#{exchange_rate}.json"

    # Parse the JSON response adn get the rate in float
    Oj.load(res.body)['bpi'][exchange_rate]['rate_float']
  end
end
