require 'spec_helper'

describe Carousel::Response do
  
  let(:raw_xml)               { read_xml(:success_order_response) }
  let(:raw_fail_xml)          { read_xml(:error_order_response) }
  let(:failed_response)       { Carousel::Response.new(raw_fail_xml, "order") }
  let(:successful_response)   { Carousel::Response.new(raw_xml, "order") }
  let(:message)               { {"order"=>[{"number"=>"12345", "status"=>["OK"], "details"=>[{}]}]} }

  describe '#initialize' do
    it 'sets the raw_response. response, and type' do
      expect(successful_response.instance_variable_get(:@raw_response)).to eq(raw_xml)
      expect(successful_response.instance_variable_get(:@type)).to eq("order")
      expect(successful_response.response).to eq(message)
    end
  end

  describe '#failure?' do
    context 'the status is "OK"' do
      it 'returns false' do
        expect(successful_response.failure?).to eq(false)
      end
    end
    context 'the status is not "OK"' do
      it 'returns true' do
        expect(failed_response.failure?).to eq(true)
      end
    end
  end

  describe '#success?' do
    context 'the status is "OK"' do
      it 'returns true' do
        expect(successful_response.success?).to eq(true)
      end
    end
    context 'the status is not "OK"' do
      it 'returns false' do
        expect(failed_response.success?).to eq(false)
      end
    end
  end

  describe '#status' do
    context 'with a successful response' do
      it 'returns succesful status code' do
        expect(successful_response.status).to eq("OK")
      end
    end
    context 'with an failed response' do
      it 'returns a failed status code' do
        expect(failed_response.status).to eq("ERROR")
      end
    end
  end

  describe '#message' do
    it 'returns the details from the response' do
      expect(successful_response.message).to eq({})
    end
  end

  describe '#parse_response' do
    it 'returns the parsed xml' do
      expect(successful_response.parse_response(raw_xml)).to eq(message)
    end
  end
end