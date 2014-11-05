require 'spec_helper'

describe Carousel::Country do

  
  describe '.map' do
    context 'with the code in the COUNTRY_MAP' do
      it 'returns the value for the given code' do
        expect(Carousel::Country.map("US")).to eq("US")
      end
    end
    context 'without the code in the COUNTRY_MAP' do
      it 'returns the given code' do
        expect(Carousel::Country.map("AAA")).to eq("AAA")
      end
    end
  end
end