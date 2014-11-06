require 'spec_helper'

describe Carousel::Order do
  let(:client)  { Carousel::Client.new("the_username", "the_password") }
  let(:order_request) { Carousel::Order.new(client) }

  describe '#build_order_request' do
    it 'builds an xml file based on the order' do
      expect(order_request.build_order_request(order_hash)).to eq(read_xml(:test_order))
    end
  end

  describe 'private#build_address' do
    before do
      @xml = ::Builder::XmlMarkup.new :indent => 2
      @xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
    end

    context 'given a billing address' do
      it 'adds the address tags with the "inv" prefix' do
        expect(order_request.send(:build_address, @xml, address_hash, :billing)).to eq(read_xml(:test_shipping_address_builder))
      end
    end
    context 'given any other address' do
      it 'adds the address tags to the xml file' do
        expect(order_request.send(:build_address, @xml, address_hash, "shipping")).to eq(read_xml(:test_address_builder))
      end
    end
  end

  describe 'private#build_line_items' do
    it 'adds the line_items tags to the xml file under orderline' do
      xml = ::Builder::XmlMarkup.new :indent => 2
      xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
      order_request.send(:build_line_items, xml, order_hash)
      expect(xml.target!).to eq(read_xml(:test_line_items))
    end
  end

end