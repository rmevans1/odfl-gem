module Odfl
  module Helpers

    private
    # Helper method to validate required fields
    def requires!(hash, *params)
      params.each { |param| raise RateError, "Missing Required Parameter #{param}" if hash[param].nil? }
    end
  end
end