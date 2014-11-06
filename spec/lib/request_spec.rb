require 'spec_helper'

describe Carousel::Request do

  let(:client)  { Carousel::Client.new("the_username", "the_password") }
  let(:request) { Carousel::Request.new(client) }

  describe '#initialize' do
    it 'sets the client' do
      expect(request.instance_variable_get(:@client)).to eq(client)
    end
  end

  describe '#construct_xml' do
    it 'creates xml with a given block' do
      expect(request.construct_xml("order"){|xml| xml.test "test"}).to eq(read_xml(:test_request))
    end
  end

  describe '#build_user' do
    it 'adds user and password to xml file' do
      xml = ::Builder::XmlMarkup.new :indent => 2
      xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
      expect(request.build_user(xml)).to eq(read_xml(:test_build_user))
    end
  end
end