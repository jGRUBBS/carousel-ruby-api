module Carousel
  class Inventory < Request

    PATH = "?action=stocklines"

    def build_inventory_request
      construct_xml "stock" do |xml|
        build_user xml
      end
    end

  end
end
