require 'odfl/credentials'

module Odfl
  class Shipment

    def initialize(options = {})
      @credentials = Credentials.new(options)
    end

    def rate(options = {})

    end
  end
end