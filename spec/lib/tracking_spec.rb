require 'spec_helper'

describe Carousel::Tracking do

  let(:tracking) { Carousel::Tracking.new('carousel', '123456')}

  before do
    Carousel.configure(configuration)
  end
  
  describe '#initialize' do
    it 'sets the carrier and tracking number' do
      expect(tracking.instance_variable_get(:@carrier)).to eq("carousel")
      expect(tracking.instance_variable_get(:@tracking_number)).to eq("123456")
    end
  end

  describe '#carrier_destination' do
    context 'when carrier is FedEx' do
      it 'returns the FedEx tracking url' do
        tracking.carrier = "fedex"
        expect(tracking.url).to eq("http://www.fedexuk.net/accounts/QuickTrack.aspx?consignment=123456")
      end
    end
    context 'when carrier is Carousel' do
      it 'returns the Carousel tracking url' do
        expect(tracking.url).to eq("https://web.carousel.eu/easyweb/default.asp?action=clienttrack&type=Carousel&acct1=ABC00&reference=123456")
      end
    end
  end
  describe '#url' do
    context 'when carrier is FedEx' do
      it 'returns the FedEx tracking url including the tracking number' do
        tracking.carrier = "fedex"
        expect(tracking.url).to eq("http://www.fedexuk.net/accounts/QuickTrack.aspx?consignment=123456")
      end
    end
    context 'when carrier is Carousel' do
      it 'returns the Carousel tracking url including the tracking number' do
        expect(tracking.url).to eq("https://web.carousel.eu/easyweb/default.asp?action=clienttrack&type=Carousel&acct1=ABC00&reference=123456")
      end
    end
  end
end