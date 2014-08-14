require 'spec_helper'

describe Carousel::Request do

  before do
    @client = Carousel::Client.new("the_username", "the_password")
  end

  describe '#construct_xml' do
    it 'should build the main xml with header, user, and supplied body' do
      request_type = "new_order_request"
      soap_client  = Carousel::Request.new(@client)
      soap_request = soap_client.construct_xml request_type do |xml|
        xml.test "test"
      end
      soap_request.should == xml_string(request_type, "<test>test</test>")
    end
  end

  describe '#build_header' do
    it 'should build xml header' do
      request_type = "new_order_request"
      soap_client  = Carousel::Request.new(@client)
      xml = Builder::XmlMarkup.new
      soap_request = soap_client.build_header(xml, request_type)
      soap_request.should == xml_header_string(request_type)
    end
  end

  describe '#build_user' do
    it 'should' do
      soap_client  = Carousel::Request.new(@client)
      xml = Builder::XmlMarkup.new
      soap_request = soap_client.build_user(xml)
      soap_request.should == xml_user_string
    end
  end
  
end