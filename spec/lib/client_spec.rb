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

  describe 'inventory methods' do

    let(:success_response) { read_xml(:success_inventory_response) }
    let(:response)         { client.get_inventory }
    let(:expected_upcs)    { ['1000000003642', '1000000003659', '1000000003666'] }
    let(:expected_qtys)    { ['3', '2', '2'] }
    let(:raw_xml)          { read_xml(:inventory_request) }

    before do
      stub_post("action=stocklines").with(body: raw_xml, headers: xml_headers)
        .to_return(body: success_response)
    end

    describe '#get_inventory' do

      it 'parses success response and maps results to simple array of stock hashes' do
        expect(response.response.collect{ |s| s["upc"] }).to eq(expected_upcs)
        expect(response.response.collect{ |s| s["qty"] }).to eq(expected_qtys)
        expect(response.success?).to eq(true)
      end
    end

    describe '#inventory_response' do

      it 'gets the raw inventory response from the provider' do
        expect(response.raw_response).to eq(success_response)
      end

      it 'converts provider specific language to match a uniform API' do
        original_response = client.send(:parse_response, success_response).response["stock"]
        expect(original_response.first.keys).to include('stockid') 
        expect(response.response.first.keys).to include('upc')
      end

      it 'returns a response' do
        expect(response).to be_a(Carousel::Response)
      end

    end

  end

  describe '#order_request' do
    it 'sets the path instance variable' do
      client.order_request(order_hash)
      expect(client.instance_variable_get(:@path)).to eq("/carouselwms/default.asp?action=order")
    end
    it 'returns a built request for Order' do
      order_xml = read_xml(:test_order)
      expect(client.order_request(order_hash)).to eq(order_xml)
    end
  end

  describe '#build_path' do
    it 'builds and returns the uri path' do
      expect(client).to receive(:env_path).and_return("carouselwms")
      expect(client.build_path("?action=stocklines")).to eq("/carouselwms/default.asp?action=stocklines")
    end
  end

  describe '#upcs' do
    it 'returns an array of the collected upcs' do
      inventory = [{"upc" => "123"}, {"upc" => "123456"}]
      expect(client.upcs(inventory)).to eq(["123", "123456"])
    end
  end

  describe '#mapped_inventory' do
    it 'converts provider specific terms into a uniform API' do
      inventory = [{"upc" => "123", "qty" => "3"}, {"upc" => "123456", "qty" => "0"}]
      upcs = ["123"]
      expect(client.mapped_inventory(upcs, inventory)).to eq([{quantity: 3}])
    end
  end

  describe '#request_uri' do
    it 'returns the request uri based on host and path' do
      client.path = "?action=stocklines"
      expect(client.request_uri).to eq("https://web.carousel.eu?action=stocklines")
    end
  end

  describe 'private#default_options' do
    it 'returns the default options for a Client' do
      default_options = {
        verbose: true,
        test_mode: false
      }
      expect(client.send(:default_options)).to eq(default_options)
    end
  end

  describe 'private#testing?' do
     context 'not in testing mode' do
      it 'returns false' do
        client.options[:test_mode] = false
        expect(client.send(:testing?)).to eq(false)
      end
    end
    context 'in testing mode' do
      it 'returns true' do
        expect(client.send(:testing?)).to eq(true)
      end
    end
  end

  describe 'private#verbose?' do
     context 'not in verbose mode' do
      it 'returns false' do
        client.options[:verbose] = false
        expect(client.send(:verbose?)).to eq(false)
      end
    end
    context 'in verbose mode' do
      it 'returns true' do
        expect(client.send(:verbose?)).to eq(true)
      end
    end
  end

  describe 'private#env_path' do
    context 'not in testing mode' do
      it 'returns the LIVE_PATH' do
        client.options[:test_mode] = false
        expect(client.send(:env_path)).to eq(Carousel::Client::LIVE_PATH)
      end
    end
    context 'in testing mode' do
      it 'returns TEST_PATH' do
        expect(client.send(:env_path)).to eq(Carousel::Client::TEST_PATH)
      end
    end
  end

  describe 'private#host' do
    context 'not in testing mode' do
      it 'returns the LIVE_PATH' do
        client.options[:test_mode] = false
        expect(client.send(:host)).to eq(Carousel::Client::LIVE_HOST)
      end
    end
    context 'in testing mode' do
      it 'returns TEST_PATH' do
        expect(client.send(:host)).to eq(Carousel::Client::TEST_HOST)
      end
    end
  end

  describe 'private#log' do
    before do
      @message = "test"
    end
    context 'not in verbose mode' do
      it 'returns nil' do
        expect(client.send(:log, @message)).to eq(nil)
      end
    end
    context 'in verbose mode' do
      it 'logs the message to STDOUT' do
        client.options[:verbose] = true
        output = capture_stdout { client.send(:log, @message) }
        expect(output).to eq("test\n")
      end
    end
  end

  describe 'private#http' do
    it 'returns an instance of Net::HTTP' do
      http = client.send(:http)
      host = client.send(:host)
      expect(http).to be_an_instance_of(Net::HTTP)
      expect(http.address).to eq(host)
      expect(http.port).to eq(Carousel::Client::PORT)
    end
  end

  describe 'private#request' do

    let(:success_response) { read_xml(:success_inventory_response) }
    let(:request)          { read_xml(:inventory_request) }

    it 'sets the ssl and verify mode, sends an http request, and returns a response object' do
      client.path = "?action=stocklines"
      expect(client.send(:http)).to receive(:request).and_return(success_response)
      expect(client.send(:request, request)).to eq(success_response)
      expect(client.send(:http).use_ssl?).to be(true)
      expect(client.send(:http).verify_mode).to eq(OpenSSL::SSL::VERIFY_NONE)
    end
  end

  describe 'private#post' do
    let(:request)   { read_xml(:inventory_request) }
    let(:response)  { read_xml(:success_inventory_response) }

    before do
      client.path = "?action=stocklines"
    end
    
    it 'sends a post request' do
      expect(client).to receive(:request).and_return(fake_response)
      client.send(:post, request)
    end
    it 'parses response into a Carousel::Response object' do
      expect(client).to receive(:request).and_return(fake_response)
      expect(client.send(:post, request)).to be_a(Carousel::Response)
    end
  end

  describe 'private#parse_response' do
    let(:response) { read_xml(:success_inventory_response) }

    it 'logs the response' do
      client.options[:verbose] = true
      expect(client).to receive(:log).with(response)
      client.send(:parse_response, response)
    end

    it 'parses response into a Carousel::Response object' do
      expect(client.send(:parse_response, response)).to be_a(Carousel::Response)
    end
  end

  describe 'private#map_results' do
    it 'flattens the results and maps them' do
      results = [{test: [1,2,3]}, {example: [2,3,4]}, {test: [1,2,3], stockid: [5,6,7,8]}]
      expected_result = [{test: 1}, {example: 2}, {test: 1, stockid: 5}]

      expect(client).to receive(:flatten_results).and_return(expected_result)
      expect(client.send(:map_results, results)).to eq(expected_result)
    end
  end

  describe 'private#flatten_results' do
    it 'sets the value for each hash key to the first item in the value array' do
      results = [{test: [1,2,3]}, {example: [2,3,4]}, {test: [1,2,3], example: [5,6,7,8]}]
      expected_result = [{test: 1}, {example: 2}, {test: 1, example: 5}]
      expect(client.send(:flatten_results, results)).to eq(expected_result)
    end
  end

  describe 'private#map_keys' do
    context 'with a key in the KEYS_MAP' do
      it 'returns the value for the given key' do
        key = "stockid"
        expect(client.send(:map_keys, key)).to eq(Carousel::Client::KEYS_MAP[key])
      end
    end
    context 'without a key in the KEYS_MAP' do
      it 'returns the key' do
        key = "test"
        expect(client.send(:map_keys, key)).to eq(key)
      end
    end
  end

end