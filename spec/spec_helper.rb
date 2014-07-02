# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, :development)
require 'hashie'
require 'trebbianno'

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end

def xml_string(type, body)
  xml  = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
  xml += "<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\">"
  xml += xml_header_string(type)
  xml += "<s:Body><#{type} xmlns=\"SII\">"
  xml += xml_user_string
  xml += body
  xml += "</#{type}></s:Body></s:Envelope>"
end

def xml_header_string(type)
  xml  = "<s:Header><a:Action s:mustUnderstand=\"1\">SII/ISIIService/#{type}</a:Action>"
  xml += "<a:MessageID>urn:uuid:56b55a70-8bbc-471d-94bb-9ca060bcf99f</a:MessageID>"
  xml += "<a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo>"
  xml += "<a:To s:mustUnderstand=\"1\">https://www.trebbianno.us/webservices/SIIService.svc</a:To></s:Header>"
end

def xml_user_string
  xml  = "<user xmlns:b=\"http://schemas.datacontract.org/2004/07/\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\">"
  xml += "<b:user_name>&lt;![CDATA[the_username]]&gt;</b:user_name><b:user_password>&lt;![CDATA[the_password]]&gt;</b:user_password></user>"
end

def xml_address_string(type, address)
  full_name = "#{address[:first_name]} #{address[:last_name]}"
  xml  = "<b:#{type}_NAME>&lt;![CDATA[#{full_name}]]&gt;</b:#{type}_NAME>"
  xml += "<b:#{type}_ADDRESS_1>&lt;![CDATA[#{address[:address1]}]]&gt;</b:#{type}_ADDRESS_1>"
  xml += "<b:#{type}_ADDRESS_2>&lt;![CDATA[#{address[:address2]}]]&gt;</b:#{type}_ADDRESS_2>"
  xml += "<b:#{type}_ADDRESS_3>&lt;![CDATA[#{address[:address3]}]]&gt;</b:#{type}_ADDRESS_3>"
  xml += "<b:#{type}_ADDRESS_CITY>#{address[:city]}</b:#{type}_ADDRESS_CITY>"
  xml += "<b:#{type}_ADDRESS_COUNTRY>#{address[:country]}</b:#{type}_ADDRESS_COUNTRY>"
  xml += "<b:#{type}_ADDRESS_STATE>#{address[:state]}</b:#{type}_ADDRESS_STATE>"
  xml += "<b:#{type}_ADDRESS_ZIP>#{address[:zipcode]}</b:#{type}_ADDRESS_ZIP>"
  xml += "<b:#{type}_TELEPHONE>#{address[:phone]}</b:#{type}_TELEPHONE>"
end

def xml_line_items_string(order)
  xml  = "<b:Order_Details>"
  order[:line_items].each do |line_item|
    xml += "<b:Order_Detail_New>"
    xml += "<b:PRICE>#{line_item[:price]}</b:PRICE>"
    xml += "<b:QUANTITY>#{line_item[:quantity]}</b:QUANTITY>"
    xml += "<b:SIZE>#{line_item[:size]}</b:SIZE>"
    xml += "<b:sku>#{line_item[:sku]}</b:sku>"
    xml += "</b:Order_Detail_New>"
  end
  xml += "</b:Order_Details>"
end

def xml_order_request_string(order)
  xml  = "<ohn xmlns:b=\"http://schemas.datacontract.org/2004/07/\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\">"
  xml += "<b:SERVICE>90</b:SERVICE>"
  xml += "<b:USER1>&lt;![CDATA[http://example.com/R123123123/invoice]]&gt;</b:USER1>"
  xml += "<b:CARRIER>FEDEX</b:CARRIER>"
  xml += "<b:CUSTOMER_CODE/><b:DELIVERY_GIFT_WRAP/>"
  xml += "<b:DELIVERY_MESSAGE>&lt;![CDATA[Happy Birthday!]]&gt;</b:DELIVERY_MESSAGE>"
  xml += "<b:EMAIL>someone@somehwere.com</b:EMAIL>"
  xml += "<b:ORDER_ID>R123123123</b:ORDER_ID>"
  xml += "<b:ORDER_TYPE>OO</b:ORDER_TYPE>"
  xml += "<b:DELIVERY_FROM i:nil=\"true\"/><b:DELIVERY_TO i:nil=\"true\"/>"
  xml += "<b:DELIVERY_ID i:nil=\"true\"/><b:FREIGHT_ACCOUNT i:nil=\"true\"/>"
  xml += xml_address_string("CUSTOMER", order[:billing_address])
  xml += xml_address_string("DELIVERY", order[:shipping_address])
  xml += xml_line_items_string(order)
  xml += "</ohn>"
end

def order_hash
{
  carrier: "FEDEX",
  billing_address:  { 
    first_name: "John",
    last_name:  "Smith",
    address1:   "123 Here Now",
    address2:   "2nd Floor",
    address3:   "",
    city:       "New York",
    state:      "New York",
    country:    "US",
    zipcode:    "10012",
    phone:      "123-123-1234"
  },
  shipping_address: {
    first_name: "John",
    last_name:  "Smith",
    address1:   "123 Here Now",
    address2:   "2nd Floor",
    address3:   "",
    city:       "New York",
    state:      "New York",
    country:    "US",
    zipcode:    "10012",
    phone:      "123-123-1234"
  },
  gift_wrap:    "true",
  gift_message: "Happy Birthday!",
  email:        "someone@somehwere.com",
  number:       "R123123123",
  type:         "OO",
  line_items: [
    {
      price:    "127.23",
      quantity: "1",
      sku:      "123332211",
      size:     "XS"
    }
  ],
  shipping_code: "90",
  invoice_url:   "http://example.com/R123123123/invoice"
}
end