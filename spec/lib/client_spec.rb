require 'spec_helper'

describe Carousel::Client do

  let(:username) { "the_username" }
  let(:password) { "the_password" }
  let(:options)  { { verbose: true, test_mode: true } }
  let(:client)   { Carousel::Client.new(username, password, options) }

  describe '#initialize' do
    it 'sets the @username, @password and @options' do
      expect(client.username).to eq(username)
      expect(client.password).to eq(password)
      expect(client.options).to  eq(options)
    end
  end

  describe '#send_order_request' do
    
    let(:success_response) { read_xml(:success_order_response) }
    let(:error_response)   { read_xml(:error_order_response) }
    let(:response)         { client.send_order_request(order_hash) }

    it 'parses a success response' do
      stub_post("action=order").to_return(body: success_response)
      expect(response.success?).to eq(true)
    end

    it 'parses an error response' do
      stub_post("action=order").to_return(body: error_response)
      expect(response.success?).to eq(false)
      expect(response.message).to  eq('Bad postcode')
    end
  end

  describe '#get_inventory' do

    let(:success_response) { read_xml(:success_inventory_response) }
    let(:response)         { client.get_inventory }
    let(:expected_upcs)    { ['1000000003642', '1000000003659', '1000000003666'] }
    let(:expected_qtys)    { ['3', '2', '2'] }

    it 'parses success response and maps results to simple array of stock hashes' do
      stub = stub_post("action=stocklines").with(body: read_xml(:inventory_request), headers: xml_headers)
                                           .to_return(body: success_response)
      expect(response.response.collect{ |s| s["upc"] }).to eq(expected_upcs)
      expect(response.response.collect{ |s| s["qty"] }).to eq(expected_qtys)
      expect(response.success?).to eq(true)
      expect(stub).to have_been_requested
    end
  end

  describe 'private#default_options' do
    it 'is pending'
  end

  describe 'private#testing?' do
    it 'is pending'
  end

  describe 'private#verbose?' do
    it 'is pending'
  end

  describe 'private#host' do
    it 'is pending'
  end

  describe 'private#path' do
    it 'is pending'
  end

  describe 'private#log' do
    context 'not in verbose mode' do
      it 'is pending'
    end
    context 'in verbose mode' do
      it 'is pending'
    end
  end

  describe 'private#post' do
    it 'is pending'
  end

  describe 'private#parse_response' do
    it 'is pending'
  end

end