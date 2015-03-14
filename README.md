Bestchange Rates allows to get actual rates from bestchange.ru

## Installation

```ruby

gem 'bestchange_rates'

```

## Usage

```ruby

   bestchange_rates = BestchangeRates.new

   # get list of Exchangers
   bestchange_rates.exchangers

   # get list of currencies
   bestchange_rates.currencies

   # get rates for direction
   bestchange_rates.rates 'WMZ' => 'Сбербанк'

```