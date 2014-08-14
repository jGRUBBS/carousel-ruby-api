module Carousel
  class Shipping

    SHIPPING_MAP = {
      "next-day" => "ND",
      "express"  => "EXPRESS",
      "standard" => "ECONOMY"
    }

    def self.map(code)
      SHIPPING_MAP[code] || code
    end

  end
end
