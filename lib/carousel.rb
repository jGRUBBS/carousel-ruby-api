require "carousel/version"
require "carousel/response"
require "carousel/client"
require "carousel/request"
require "carousel/order"
require "carousel/inventory"
require "carousel/country"
require "carousel/shipping"
require "carousel/tracking"

module Carousel

  @config = {
    account: ''
  }

  def self.configure(opts = {})
    opts.each do |k, v| 
      if @config.keys.include? k.to_sym 
        @config[k.to_sym] = v
      else
        # unsupported configuration
        p 'unsupported configuration option for Carousel fulfillment'
      end
    end
    validate_configuration
  end

  def self.validate_configuration
    @config.each do |k, v|
      if k == :account && v.empty?
        raise 'Carousel account needs to be set'
      end
    end
  end

  def self.config
    @config
  end
  
end