require 'net/https'
require 'xmlsimple'

module Carousel
  class Client

    TEST_HOST = "web.carousel.eu"
    TEST_PATH = "carouselwms"
    LIVE_HOST = "web.carousel.eu"
    LIVE_PATH = "carouselwms"
    PORT      = 443
    KEYS_MAP  = { "stockid" => "upc" }

    attr_accessor :username, :password, :options, :response, :type, :request_uri, :path

    def initialize(username, password, options = {})
      raise "Username is required" unless username
      raise "Password is required" unless password

      @username = username
      @password = password
      @options  = default_options.merge!(options)
    end

    def send_order_request(order)
      request  = order_request(order)
      post(request)
    end

    def get_inventory
      request = Inventory.new(self).build_inventory_request
      @path   = build_path(Inventory::PATH)
      inventory_response(request)
    end

    def inventory_response(request)
      response = post(request)
      response.response = map_results(response.response['stock'])
      response
    end

    def order_request(order)
      @path = build_path(Order::PATH)
      Order.new(self).build_order_request(order)
    end

    def build_path(path)
      "/#{env_path}/default.asp#{path}"
    end

    def upcs(inventory)
      inventory.collect { |s| s["upc"] }
    end

    def mapped_inventory(upcs, inventory)
      inventory.collect do |stock| 
        if upcs.include?(stock["upc"])
          { quantity: stock["qty"].to_i }
        end
      end.compact
    end

    def request_uri
      "https://#{host}#{@path}"
    end

    private
    def default_options
      { 
        verbose: true,
        test_mode: false
      }
    end

    def testing?
      @options[:test_mode]
    end

    def verbose?
      @options[:verbose]
    end

    def env_path
      testing? ? TEST_PATH : LIVE_PATH
    end

    def host
      testing? ? TEST_HOST : LIVE_HOST
    end

    def log(message)
      return unless verbose?
      puts message
    end

    def http
      @http ||= Net::HTTP.new(host, PORT)
    end

    def request(xml_request)
      request              = Net::HTTP::Post.new(@path)
      request.body         = xml_request
      request.content_type = 'application/xml'
      http.use_ssl         = true
      http.verify_mode     = OpenSSL::SSL::VERIFY_NONE
      http.request(request)
    end

    def post(xml_request)
      response = request(xml_request)
      parse_response(response.body)
    end

    def parse_response(xml_response)
      log(xml_response)
      @response = Response.new(xml_response, @type)
    end

    def map_results(results)
      results = flatten_results(results)
      results.map do |h|
        h.inject({ }) { |x, (k,v)| x[map_keys(k)] = v; x }
      end
    end

    def flatten_results(results)
      @flattened ||= results.map do |h| 
        h.each { |k,v| h[k] = v[0] }
      end
    end

    def map_keys(key)
      KEYS_MAP[key] || key
    end

  end
end
