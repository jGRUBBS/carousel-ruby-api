module Carousel
  class Tracking

    attr_accessor :carrier

    FEDEX    = "http://www.fedexuk.net/accounts/QuickTrack.aspx?consignment=:tracking_number"
    CAROUSEL = "https://web.carousel.eu/easyweb/default.asp?action=clienttrack&type=Carousel&acct1=BEC01&reference=:tracking_number"

    def initialize(carrier, tracking_number)
      @carrier         = carrier
      @tracking_number = tracking_number
    end

    def carrier_destination
      self.class.const_get(carrier.upcase)
    end

    def url
      carrier_destination.gsub(':tracking_number', @tracking_number)
    end

  end
end