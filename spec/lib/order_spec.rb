require 'spec_helper'

describe Carousel::Order do

  before do
    @client       = Carousel::Client.new("the_username", "the_password")
    @order_client = Carousel::Order.new(@client)
    @xml          = Builder::XmlMarkup.new
  end

  describe '#build_order_request' do
    it 'should' do
      response = @order_client.build_order_request(order_hash)
      @client.type.should == "new_order_entry"
      request_body = xml_order_request_string(order_hash)
      response.should == xml_string("new_order_entry", request_body)
    end
  end

  describe 'private#build_address' do
    it 'should build the proper address xml' do
      type    = "CUSTOMER"
      request = @order_client.send(:build_address, @xml, type, order_hash[:shipping_address])
      request.should == xml_address_string(type, order_hash[:shipping_address])
    end
  end

  describe 'private#build_line_items' do
    it 'should build the proper line items xml' do
      request = @order_client.send(:build_line_items, @xml, order_hash)
      request.should == xml_line_items_string(order_hash)
    end
  end

end