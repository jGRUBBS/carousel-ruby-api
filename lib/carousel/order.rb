module Carousel
  class Order < Request

    PATH = "?action=order"

    def build_order_request(order)
      construct_xml "orders" do |xml|

        xml.order do

          build_user xml

          xml.customerref    order[:number]
          xml.ordernumber    order[:number]
          xml.shippingmethod Shipping.map(order[:shipping_method])
          xml.giftnote       order[:gift_message] if order[:gift_message].present?

          build_address xml, order[:shipping_address], :shipping
          build_address xml, order[:billing_address], :billing
          build_line_items xml, order

        end

      end
    end

    private

    def build_address(xml, address, type)
      prefix = type == :billing ? 'inv' : ''
      xml.tag! "#{prefix}name"         "#{address[:first_name]} #{address[:last_name]}"
      xml.tag! "#{prefix}addressline1" address[:address1]
      xml.tag! "#{prefix}addressline2" address[:address2]
      xml.tag! "#{prefix}towncity"     address[:city]
      xml.tag! "#{prefix}postcode"     address[:zipcode]
      xml.tag! "#{prefix}country"      Country.map(address[:country])
      xml.tag! "#{prefix}contactphone" address[:phone]
    end

    def build_line_items(xml, order)
      order[:line_items].each do |line_item|
        xml.tag! 'orderline', :number => order[:number] do
          xml.ordernumber order[:number]
          xml.sku         line_item[:sku]
          xml.qty         line_item[:quantity]
        end
      end
    end

  end
end
