require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
require 'bundler/setup'
require 'carousel'
require 'rspec'
require 'webmock/rspec'
require 'hashie'

Bundler.setup

WebMock.disable_net_connect!(:allow => "codeclimate.com")

RSpec.configure do |config|
  config.include WebMock::API
  config.before(:all, &:silence_output)
  config.after(:all,  &:enable_output)
end

def read_xml(type)
  File.read( File.expand_path("spec/fixtures/#{type}.xml") )
end

def fixture(type)
  XmlSimple.xml_in( read_xml(type) )
end

def base_url
  'https://web.carousel.eu/carouselwms/default.asp?'
end

def stub_get(path)
  stub_request(:get, "#{base_url}#{path}")
end

def stub_post(path)
  stub_request(:post, "#{base_url}#{path}")
end

def xml_headers
  {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/xml', 'User-Agent'=>'Ruby'}
end

def json_post_headers
  {
    'Accept'          => '*/*', 
    'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 
    'Content-Type'    => 'application/json', 
    'User-Agent'      => 'Ruby'
  }
end

def success_response
  {
    'Response' => {
      'CallStatus' => {
        'Code'     => 0,
        'Message'  => {},
        'Success'  => true
      }
    }
  }
end

def error_product_response
  {
    'CallStatus' => {
      'Success' => false,
      'Code'    => 100,
      'Message' => 'Error Submitting Product Master: LJ-W-BERN-S-GW - Error. Product Code already exists.'
    }
  }
end

def configuration
  { 
    account: 'ABC00'
  }
end

def address_hash
  {
    city:       'Windsor',
    country:    'GB',
    first_name: 'Stephen',
    last_name:  'Jones',
    address1:   '23 Victoria Street',
    address2:   '',
    phone:      '0123 336 6676',
    zipcode:    'SL4 1HE'
  }
end

def line_items_array
  [
    {
      sku:      100083,
      quantity: 2
    }
  ]
end

def company_hash
  {
    code:        'IND001',
    description: 'Indigina'
  }
end

def order_hash
  {
    number:           123456,
    email:            'stephen.jones@gmail.com',
    shipping_address: address_hash,
    billing_address:  address_hash,
    line_items:       line_items_array,
    warehouse:        'DC123',
    date:             '2013-12-12',
    shipping_method:  'EU:standard'
  }
end

def company_order_hash
  order_hash.merge(company: company_hash)
end

def company_address_hash
  {
    city:         'High Wycombe',
    country:      'GB',
    country_name: 'Buckinghamshire',
    address1:     'The Farthings',
    address2:     'Sandpits Lane',
    address3:     'Beaconsfield',
    zipcode:      'HP8 TTT'
  }
end

def company_submit_hash
  {
    code: 123456,
    description: 'My Test company',
    address: company_address_hash
  }
end

def fake_response
  Hashie::Mash.new( {body: read_xml(:success_order_response)} )
end


public
# Redirects stderr and stout to /log/spec.log
def silence_output
  # Store the original stderr and stdout in order to restore them later
  @original_stderr = $stderr
  @original_stdout = $stdout

  # Redirect stderr and stdout
  $stderr = File.new(log_file, 'w')
  $stdout = File.new(log_file, 'w')
end

def log_file
  File.join(File.dirname(__FILE__), 'logs', 'spec.log')
end

# Replace stderr and stdout so anything else is output correctly
def enable_output
  $stderr = @original_stderr
  $stdout = @original_stdout
  @original_stderr = nil
  @original_stdout = nil
  `rm #{log_file} && touch #{log_file}`
end

def capture_stdout(&block)
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  fake.string
end
