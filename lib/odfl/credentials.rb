require 'odfl/helpers'

module Odfl
  class Credentials
    include Helpers
    attr_reader :odfl4MeUser, :odfl4MePassword, :odflCustomerAccount

    # In order to use the ODFL rates API you must have a odfl account
    # Vist {http://www.odfl.com Old Dominion Freight Line} for more information
    # @param [String] user - ODFL username
    # @param [String] password - ODFL password
    # @param [String] account - ODFL account number
    #
    # return a Odfl::Credentials object
    def initialize(options = {})
      requires!(options, :user, :password, :account)
      @odfl4MeUser = options[:user]
      @odfl4MePassword = options[:password]
      @odflCustomerAccount = options[:account]
    end
  end
end