# encoding : utf-8

MoneyRails.configure do |config|

  # To set the default currency
  #
  Money.default_currency = Money::Currency.new("CUP")
  # Set default bank object
  #
  # Example:
  # config.default_bank = EuCentralBank.new

  # Add exchange rates to current money bank object.
  # (The conversion rate refers to one direction only)
  #
  # Example:
  # config.add_rate "USD", "CAD", 1.24515
  # config.add_rate "CAD", "USD", 0.803115

  # To handle the inclusion of validations for monetized fields
  # The default value is true
  #
  # config.include_validations = true

  # Default ActiveRecord migration configuration values for columns:
  #
  config.amount_column = {
    prefix: '', # column name prefix
    postfix: '_cents', # column name  postfix
    column_name: nil, # full column name (overrides prefix, postfix and accessor name)
    type: :integer, # column type
    present: true, # column will be created
    null: false, # other options will be treated as column options
    default: 0
  }

  config.currency_column = {
    prefix: '',
    postfix: '_currency',
    column_name: nil,
    type: :string,
    present: true,
    null: false,
    default: 'CUP'
  }
  config.register_currency = {
    :priority => 2,
    :iso_code => "USD",
    :name => "United States Dollar",
    #:symbol              => "$ ",
    :symbol => "USD ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :thousands_separator => ",",
    :decimal_mark => "."
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "EUR",
    :iso_numeric => "978",
    :name => "Euro",
    #:symbol          => "€ ",
    :symbol => "EUR ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "CUP",
    :iso_numeric => "978",
    :name => "CUP",
    #:symbol          => "€ ",
    :symbol => "CUP ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "CAD",
    :iso_numeric => "978",
    :name => "CAD",
    #:symbol          => "€ ",
    :symbol => "CAD ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "GBP",
    :iso_numeric => "978",
    :name => "GBP",
    #:symbol          => "€ ",
    :symbol => "GBP ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "AED",
    :iso_numeric => "978",
    :name => "AED",
    #:symbol          => "€ ",
    :symbol => "AED ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "AUD",
    :iso_numeric => "978",
    :name => "AUD",
    #:symbol          => "€ ",
    :symbol => "AUD ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "CHF",
    :iso_numeric => "978",
    :name => "CHF",
    #:symbol          => "€ ",
    :symbol => "CHF ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "CZK",
    :iso_numeric => "978",
    :name => "CZK",
    #:symbol          => "€ ",
    :symbol => "CZK ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "DKK",
    :iso_numeric => "978",
    :name => "DKK",
    #:symbol          => "€ ",
    :symbol => "DKK ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "HKD",
    :iso_numeric => "978",
    :name => "HKD",
    #:symbol          => "€ ",
    :symbol => "HKD ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "HRK",
    :iso_numeric => "978",
    :name => "HRK",
    #:symbol          => "€ ",
    :symbol => "HRK ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "HUF",
    :iso_numeric => "978",
    :name => "HUF",
    #:symbol          => "€ ",
    :symbol => "HUF ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "JPY",
    :iso_numeric => "978",
    :name => "JPY",
    #:symbol          => "€ ",
    :symbol => "JPY ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "MXN",
    :iso_numeric => "978",
    :name => "MXN",
    #:symbol          => "€ ",
    :symbol => "MXN ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "NOK",
    :iso_numeric => "978",
    :name => "NOK",
    #:symbol          => "€ ",
    :symbol => "NOK ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "NZD",
    :iso_numeric => "978",
    :name => "NZD",
    #:symbol          => "€ ",
    :symbol => "NZD ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "PLN",
    :iso_numeric => "978",
    :name => "PLN",
    #:symbol          => "€ ",
    :symbol => "PLN ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "RON",
    :iso_numeric => "978",
    :name => "RON",
    #:symbol          => "€ ",
    :symbol => "RON ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "RUB",
    :iso_numeric => "978",
    :name => "RUB",
    #:symbol          => "€ ",
    :symbol => "RUB ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "SAR",
    :iso_numeric => "978",
    :name => "SAR",
    #:symbol          => "€ ",
    :symbol => "SAR ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "SEK",
    :iso_numeric => "978",
    :name => "SEK",
    #:symbol          => "€ ",
    :symbol => "SEK ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "SGD",
    :iso_numeric => "978",
    :name => "SGD",
    #:symbol          => "€ ",
    :symbol => "SGD ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "TRY",
    :iso_numeric => "978",
    :name => "TRY",
    #:symbol          => "€ ",
    :symbol => "TRY ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "ZAR",
    :iso_numeric => "978",
    :name => "ZAR",
    #:symbol          => "€ ",
    :symbol => "ZAR ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "ILS",
    :iso_numeric => "978",
    :name => "ILS",
    #:symbol          => "€ ",
    :symbol => "ILS ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "JOD",
    :iso_numeric => "978",
    :name => "JOD",
    #:symbol          => "€ ",
    :symbol => "JOD ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "KES",
    :iso_numeric => "978",
    :name => "KES",
    #:symbol          => "€ ",
    :symbol => "KES ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "THB",
    :iso_numeric => "978",
    :name => "THB",
    #:symbol          => "€ ",
    :symbol => "THB ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }

  config.register_currency = {
    :priority => 2,
    :iso_code => "TND",
    :iso_numeric => "978",
    :name => "TND",
    #:symbol          => "€ ",
    :symbol => "TND ",
    #:symbol_first        => true,
    :subunit => "Cent",
    :subunit_to_unit => 100,
    :separator => ".",
    :delimiter => ","
  }
  # Register a custom currency
  #
  # Example:
  # config.register_currency = {
  #   priority:            1,
  #   iso_code:            "EU4",
  #   name:                "Euro with subunit of 4 digits",
  #   symbol:              "€",
  #   symbol_first:        true,
  #   subunit:             "Subcent",
  #   subunit_to_unit:     10000,
  #   thousands_separator: ".",
  #   decimal_mark:        ","
  # }

  # Specify a rounding mode
  # Any one of:
  #
  # BigDecimal::ROUND_UP,
  # BigDecimal::ROUND_DOWN,
  # BigDecimal::ROUND_HALF_UP,
  # BigDecimal::ROUND_HALF_DOWN,
  # BigDecimal::ROUND_HALF_EVEN,
  # BigDecimal::ROUND_CEILING,
  # BigDecimal::ROUND_FLOOR
  #
  # set to BigDecimal::ROUND_HALF_EVEN by default
  #

  config.rounding_mode = BigDecimal::ROUND_HALF_UP
  config.no_cents_if_whole = false
  # Set default money format globally.
  # Default value is nil meaning "ignore this option".
  # Example:
  #
  config.default_format = {
    no_cents_if_whole: false,
    symbol: nil,
    sign_before_symbol: nil
  }

  # If you would like to use I18n localization (formatting depends on the
  # locale):
  config.locale_backend = :i18n
  #
  # Example (using default localization from rails-i18n):
  #
  # I18n.locale = :en
  # Money.new(10_000_00, 'USD').format # => $10,000.00
  # I18n.locale = :es
  # Money.new(10_000_00, 'USD').format # => $10.000,00
  #
  # For the legacy behaviour of "per currency" localization (formatting depends
  # only on currency):
  config.locale_backend = :currency
  #
  # Example:
  # Money.new(10_000_00, 'USD').format # => $10,000.00
  # Money.new(10_000_00, 'EUR').format # => €10.000,00
  #
  # In case you don't need localization and would like to use default values
  # (can be redefined using config.default_format):
  # config.locale_backend = nil

  # Set default raise_error_on_money_parsing option
  # It will be raise error if assigned different currency
  # The default value is false
  #
  # Example:
  # config.raise_error_on_money_parsing = false
end
