module Carousel
  class Response

    attr_accessor :response, :raw_response

    def initialize(raw_response, type)
      @raw_response = raw_response
      @response     = parse_response(raw_response)
      @type         = type
    end

    def failure?
      !success?
    end

    def success?
      status == "OK"
    end

    def status
      if @kind == "stock"
        @response.first["status"]
      else
        @response[@kind][0]["status"][0]
      end
    end

    def message
      @response["order"][0]["details"][0]
    end

    def parse_response(xml_response)
      return nil if xml_response.nil?
      parsed = XmlSimple.xml_in(xml_response)
      @kind  = parsed.first[0]
      parsed
    end

  end
end
