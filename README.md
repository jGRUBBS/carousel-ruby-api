# Carousel

[![Build Status](https://travis-ci.org/jGRUBBS/carousel-ruby-api.svg)](https://travis-ci.org/jGRUBBS/carousel-ruby-api)
[![Code Climate](https://codeclimate.com/github/jGRUBBS/carousel-ruby-api/badges/gpa.svg)](https://codeclimate.com/github/jGRUBBS/carousel-ruby-api)
[![Test Coverage](https://codeclimate.com/github/jGRUBBS/carousel-ruby-api/badges/coverage.svg)](https://codeclimate.com/github/jGRUBBS/carousel-ruby-api)

Ruby library for interfacing with the Carousel Fulfillment API

## Installation

Add this line to your application's Gemfile:

    gem 'carousel-ruby-api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install carousel-ruby-api

## Usage

Send order request

```ruby

order = {
  shipping_address: {
    first_name: "John",
    last_name:  "Smith",
    address1:   "123 Here Now",
    address2:   "2nd Floor",
    city:       "New York",
    country:    "US",
    zipcode:    "10012",
    phone:      "123-123-1234"
  },
  billing_address: {
    first_name: "John",
    last_name:  "Smith",
    address1:   "123 Here Now",
    address2:   "2nd Floor",
    city:       "New York",
    state:      "NY",
    country:    "US",
    zipcode:    "10012",
    phone:      "123-123-1234"
  },
  number:       "R123123123",
  orderdate:    "2014-06-16",
  line_items: [
    {
      price:    "127.23",
      quantity: "1",
      sku:      "123332211"
    }
  ],
  gift_message:    "Happy B-Day!"
  shipping_method: "next-day", # or "express" or "standard"
  shipping_cost:   "20.00",
  invoice_url:   "http://example.com/R123123123/invoice"
}

client   = Carousel::Client.new("username", "password")
response = client.send_order_request(order)

if response.success?
  # DO SOMETHING
else
  # QUEUE REQUEST, STORE AND RAISE ERRORS
end

```

Get inventory

```ruby

client    = Carousel::Client.new("username", "password")
inventory = client.get_inventory

inventory.each do |stock|
  ...
end

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
