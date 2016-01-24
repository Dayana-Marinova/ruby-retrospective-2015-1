EXCHANGE_RATE = {usd: 1.7408, eur: 1.9557, gbp: 2.6415, bgn: 1}

def convert_to_bgn(price, currency)
  (price * EXCHANGE_RATE[currency]).round(2)
end

def compare_prices(price_one, currency_one, price_two, currency_two)
  (price_one * EXCHANGE_RATE[currency_one]) <=>
  (price_two * EXCHANGE_RATE[currency_two])
end
