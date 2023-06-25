Money.default_currency = Money::Currency.new("USD")
Money.locale_backend = nil
Money.rounding_mode = BigDecimal::ROUND_HALF_UP

MoneyRails.configure do |config|
  config.default_format = {
    no_cents_if_whole: false,
    thousands_separator: ","
  }
end
