module Carousel
  class Tracking

    attr_accessor :carrier

    def initialize(carrier, tracking_number)
      @carrier         = carrier
      @tracking_number = tracking_number
    end

    def carrier_destination
      carrier_url(carrier.upcase)
    end

    def carrier_url(carrier)
      case carrier
      when 'FEDEX'
        "http://www.fedexuk.net/accounts/QuickTrack.aspx?" +
        "consignment=:tracking_number"
      when 'CAROUSEL'
        "https://web.carousel.eu/easyweb/default.asp?" +
        "action=clienttrack&type=Carousel&" +
        "acct1=#{Carousel.config[:account]}&reference=:tracking_number"
      end
    end

    def url
      carrier_destination.gsub(':tracking_number', @tracking_number)
    end

  end
end