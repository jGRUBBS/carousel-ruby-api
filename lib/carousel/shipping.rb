module Carousel
  class Shipping

    SHIPPING_MAP = {
      "EU:next-day" => "EXPRESS",
      "EU:standard" => "ECONOMY",
      "UK:next-day" => "ND",
      "US:standard" => "EXPRESS",
      "AU:standard" => "ECONOMY",
      "KR:standard" => "ECONOMY",
      "SG:standard" => "ECONOMY"
    }

    def self.map(code)
      SHIPPING_MAP[code] || code
    end

  end
end
