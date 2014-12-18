require "odfl/version"
require 'savon'

class Odfl

  attr_reader :originPostalCode, :originCountry, :destinationPostalCode, :destinationCountry,
              :totalCubicVolume, :cubicUnits
  attr_accessor :client, :response, :request, :freight, :accessorials, :currencyFormat

  # 1 Character Alpha Either O (outbound) or I (inbound). Defaults to "O"
  attr_accessor :movement
  # Required for ODFL Customer Account Pricing
  attr_accessor :odfl4MeUser, :odfl4MePassword, :odflCustomerAccount
  # Tariff Code for Quote Request
  # Defaults to 559
  #
  # ==== Acceptable values
  # * *559* Standard LTL (default)
  # * *698* Security Divider- Requires Linear Feet
  # * *688* Household Services Home Move
  attr_accessor :tariff
  # Mexico Service Center
  # Use for shipments to and from mexico
  #
  # ==== Acceptable values
  # * *TUS* Tulsa AZ
  # * *LRD* Laredo TX
  attr_accessor :mexicoServiceCenter
  # Get a reference number for the current quote request
  # Only use if you are actually planning to ship
  attr_accessor :requestReferenceNumber
  # Set the weight units
  # Defaults to LBS for pounds
  attr_accessor :weightUnits
  # Set the linear feet
  # Required for tariff 698- Security Divider
  attr_accessor :linearFeet

  def initialize #:notnew: stops RDoc from seeing the initialize method
    @client = Savon.client(wsdl: 'https://www.odfl.com/wsRate_v3/services/Rate/wsdl/Rate.wsdl', ssl_verify_mode: :none,
                            log: true, log_level: :debug, pretty_print_xml: true)
    self.freight = Array.new
    self.accessorials = Array.new
    self.tariff = 559
    self.currencyFormat = "USD"
    self.requestReferenceNumber = false
    self.weightUnits = "LBS"
  end

  # Allows the user to set the origin zip and country of the shipment
  #
  # ==== Attributes
  # * +zip+ - the zip code of the shipment origin
  # * +country+ - the country of the shipment origin defaults to USA
  #
  # ==== Usage
  #
  # 1. Example usage 2
  #   quote = Odfl.new
  #   quote.set_origin(20602)
  # 2. Example usage 2
  #   quote = Odfl.new
  #   quote.set_origin(90210, "USA")
  def set_origin(zip, country = "USA")
    @originPostalCode = zip
    @originCountry = country
  end

  # Allows the user to set the destination zip and country of the shipment
  #
  # ==== Attributes
  # * +zip+ - the zip code of the shipment destination
  # * +country+ - the country of the shipment destination defaults to USA
  #
  # ==== Usage
  #
  # 1. Example Usage 1
  #   quote = Odfl.new
  #   quote.set_destination(20602)
  # 2. Example Usage 2
  #   quote = Odfl.new
  #   quote.set_destination(90210, "USA")
  def set_destination(zip, country="USA")
    @destinationPostalCode = zip
    @destinationCountry = country
  end

  # Adds freight items to the current quote
  # *Note:* Either before or during the addFreight call
  # you must call the to_hash method on the freight object
  #
  # ==== Usage
  #   quote = Odfl.new
  #   quote.addFreight(pallet.to_hash)
  def addFreight(pallet)
    self.freight.push(pallet)
  end

  # Allows the user to add additional services also called accessorials
  #
  # ==== Valid Options
  # * *ARN* Arrival Notification
  # * *HYD* Lift Gate Service
  # * *COD* COD - Requires COD Amount
  # * *CA* Appointment
  # * *IND* Insurance- Requires Insurance Amount
  # * *IDC* Inside Pickup/Delivery
  # * *OVL* Overlength Article- 12' but less than 20'
  # * *RDC* Residential/Non-Commercial Pickup/Delivery
  # * *CSD* Construction Site Pickup/Delivery
  # * *CDC* Schools, Colleges, Churches Pickup/Delivery
  # * *LDC* Secured or Limited Access Pickup/Delivery
  # * *SWD* Self Storage Delivery
  # * *PFF* Protect From Freezing
  # * *HAZ* Hazardous Material
  # * *OV2* Overlength Article - 20' to 28'
  # * *DSM* Delivery Service to Mines
  # * *HSO* Scale Tickets Per Military Move (Home Moves Only)
  # * *INH* Home Move Insurance (Home Moves Only)
  #
  # ==== Usage
  #   quote = Odfl.new
  #   quote.addAccessorial("HYD")
  def addAccessorial(accessorial)
    self.accessorials.push(accessorial)
  end

  # Sets cubic volume for rate request
  #
  # ==== Attributes
  # * +totalCubicVolume+ - the total volume of the shipment
  # * +cubicUnits+ (optional)- the unit of measure for cubic volume defaults to CF for cubic feet
  #
  # ==== Usage
  #
  # 1. Example Usage 1
  #   quote = Odfl.new
  #   quote.setCubicVolume(100)
  # 2. Example Usage 2
  #   quote = Odfl.new
  #   quote.setCubicVolume(100, "CF")
  def setCubicVolume(totalCubicVolume, cubicUnits = "CF")
    @totalCubicVolume = totalCubicVolume
    @cubicUnits = cubicUnits
  end

  def get_rates
    @response = @client.call(:get_rate_estimate, message: { originPostalCode: @originPostalCode,
                                                            originCountry: @originCountry,
                                                            destinationPostalCode: @destinationPostalCode,
                                                            destinationCountry: @destinationCountry,
                                                            odfl4MeUser: self.odfl4MeUser,
                                                            odfl4MePassword: self.odfl4MePassword,
                                                            odflCustomerAccount: self.odflCustomerAccount,
                                                            tariff: self.tariff,
                                                            movement: self.movement,
                                                            mexicoServiceCenter: self.mexicoServiceCenter,
                                                            currencyFormat: self.currencyFormat,
                                                            requestReferenceNumber: self.requestReferenceNumber,
                                                            freightItems: {
                                                                Freight: self.freight
                                                            },
                                                            weightUnits: self.weightUnits,
                                                            numberPallets: self.freight.count,
                                                            linearFeet: self.linearFeet,
                                                            accessorials: {
                                                                string: self.accessorials
                                                            },
                                                            totalCubicVolume: @totalCubicVolume,
                                                            cubicUnits: @cubicUnits
                                               })
  end
end
