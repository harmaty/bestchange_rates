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

   # => [
   # {:from=>"WMZ", :to=>"Сбербанк", :exchanger=>"Wmt24", :give=>1.0, :get=>60.80405, :position=>1},
   # {:from=>"WMZ", :to=>"Сбербанк", :exchanger=>"OnlineChange", :give=>1.0, :get=>60.8039498, :position=>2},
   # {:from=>"WMZ", :to=>"Сбербанк", :exchanger=>"ExchangerWM", :give=>1.0, :get=>60.0908, :position=>3},
   # {:from=>"WMZ", :to=>"Сбербанк", :exchanger=>"WMChange24", :give=>1.0, :get=>60.0903, :position=>4},
   # {:from=>"WMZ", :to=>"Сбербанк", :exchanger=>"MonsterWM", :give=>1.0, :get=>60.0, :position=>5}
   # ]

   # bestchange api info
   bestchange_rates.info

```