def convert_to_bgn(price, currency)
  currencies = { bgn: 1, usd: 1.7408, eur: 1.9557, gbp: 2.6415 }
  (price * currencies[currency]).round(2)
end

def compare_prices(first_price, first_currency, second_price, second_currency)
  first_bgn_price = convert_to_bgn(first_price, first_currency)
  second_bgn_price = convert_to_bgn(second_price, second_currency)
  first_bgn_price <=> second_bgn_price
end
