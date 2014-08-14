module Carousel
  class Response

    attr_accessor :response

    def initialize(raw_response, type)
      @raw_response = raw_response
      @response     = parse_response(raw_response)
      @type         = type
    end

    def failure?
      !success?
    end

    def success?
      # FIXME: needs to give actual boolean parsed from response
      # @response.parsed["#{@type}_response"]["#{@type}_result"][:status] == '0001'
      true
    end

    def parse_response(xml_response)
      return nil if xml_response.blank?
      XmlSimple.xml_in(xml_response)
    end

  end
end
