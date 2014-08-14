require 'spec_helper'

describe Carousel::Client do
  before do
    @client = Carousel::Client.new("the_username", "the_password")
  end

  describe '#send_order_request' do
    it 'should send order request and return parsed respose' do
      Carousel::Order.any_instance.should_receive(:build_order_request).with(order_hash)
      @client.should_receive(:post)
      @client.send_order_request(order_hash)
    end
  end

  describe 'private#default_options' do
    it 'should return a hash' do
      @client.send(:default_options).should be_a Hash
    end
  end

  describe 'private#testing?' do
    it 'should return boolean for test mode' do
      @client.send(:testing?).should be_false
      @client.instance_variable_set(:@options, { test_mode: true })
      @client.send(:testing?).should be_true
    end
  end

  describe 'private#verbose?' do
    it 'should return boolean for verbose mode' do
      @client.send(:verbose?).should be_true
      @client.instance_variable_set(:@options, { verbose: false })
      @client.send(:verbose?).should be_false
    end
  end

  describe 'private#host' do
    it 'should' do
      @client.stub(:testing?).and_return(false)
      @client.send(:host).should == Carousel::Client::LIVE_HOST
      @client.stub(:testing?).and_return(true)
      @client.send(:host).should == Carousel::Client::TEST_HOST
    end
  end

  describe 'private#path' do
    it 'should' do
      @client.stub(:testing?).and_return(false)
      @client.send(:path).should == Carousel::Client::LIVE_PATH
      @client.stub(:testing?).and_return(true)
      @client.send(:path).should == Carousel::Client::TEST_PATH
    end
  end

  describe 'private#log' do
    context 'not in verbose mode' do
      it 'should not log message' do
        @client.stub(:verbose?).and_return(false)
        @client.should_not_receive(:puts)
        @client.send(:log, "message")
      end
    end
    context 'in verbose mode' do
      it 'should' do
        @client.stub(:verbose?).and_return(true)
        @client.should_receive(:puts).with("message")
        @client.send(:log, "message")
      end
    end
  end

  describe 'private#post' do
    it 'should use net http to post xml request' do
      path        = @client.send(:path)
      xml_request = "xml_request"
      response    = Carousel::Response.new("<xml>body</xml>", "new_request")
      header      = {'Content-Type' => 'text/xml'}
      Net::HTTP.any_instance.should_receive(:post).with(path, xml_request, header).and_return(response)
      @client.should_receive(:parse_response).with(response, nil)
      @client.should_receive(:log).with(response)
      @client.send(:post, xml_request)
    end
  end

  describe 'private#parse_response' do
    it 'should use xml simple to parse the response' do
      xml_response = "xml_response"
      XmlSimple.should_receive(:xml_in).with(xml_response)
      response = @client.send(:parse_response, xml_response)
      response.should be_a Carousel::Response
    end
  end

end