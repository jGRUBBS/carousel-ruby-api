require 'spec_helper'

describe Carousel::Inventory do

  let(:client)  { Carousel::Client.new("the_username", "the_password") }
  let(:inventory_request) { Carousel::Inventory.new(client) }

  describe '#build_inventory_request' do
    it 'constructs xml for the user' do
      expect(inventory_request.build_inventory_request).to eq(read_xml(:inventory_request))
    end
  end
end