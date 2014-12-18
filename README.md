[![Gem Version](https://badge.fury.io/rb/odfl.svg)](http://badge.fury.io/rb/odfl)
# Odfl

The gem allows you to retrieve shipping quotes from Old Dominion Freight Line.
A customer account is required to retrieve customer specific pricing. However,
an odfl account is not required to run rate quotes

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'odfl'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install odfl

## Usage

``` ruby
require 'odfl'
require 'odfl_freight'

# create a new quote object
quote = Odfl.new
# create a new freight object
pallet = OdflFreight.new

# Set basic ODFL items for quote
quote.set_origin(20602)
quote.set_destination(90210)
quote.movement = "O"

# Create a basic shipment item
pallet.ratedClass = 70
pallet.weight = 1000

# Get rates
quote.get_rates
```


## Contributing

1. Fork it ( https://github.com/rmevans1/odfl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
