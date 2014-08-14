require 'builder'

module Carousel
  class Request

    def initialize(client)
      @client = client
    end

    def construct_xml(type)
      @client.type = type
      xml = ::Builder::XmlMarkup.new :indent => 2
      xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
      xml.tag! type do
        yield(xml) if block_given?
      end
      xml.target!
    end


    def build_user(xml)
      xml.user @client.username
      xml.password @client.password
    end

  end
end
