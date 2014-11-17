require 'spec_helper'

describe Carousel::Shipping do
  describe '.map' do
    context 'with the code within the shipping map' do
      it 'returns the value for the given key' do
        expect(Carousel::Shipping.map("EU:standard")).to eq("ECONOMY")
      end
    end
    context 'with the code not in the shipping map' do
      it 'returns the given code' do
        expect(Carousel::Shipping.map("first-class")).to eq("first-class")
      end
    end
  end
end