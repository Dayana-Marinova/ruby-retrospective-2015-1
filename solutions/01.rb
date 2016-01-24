EXCHANGE_RATE = {usd: 1.7408, eur: 1.9557, gbp: 2.6415, bgn: 1}

def convert_to_bgn(price, currency)
  (price * EXCHANGE_RATE[currency]).round(2)
end

def compare_prices(price_first, currency_first, price_second, currency_second)
  calculate_first = price_first * EXCHANGE_RATE[currency_first]
  calculate_second = price_second * EXCHANGE_RATE[currency_second]
  calculate_first <=> calculate_second
end
