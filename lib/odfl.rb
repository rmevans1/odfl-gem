require "odfl/version"
require 'savon'

class Odfl

  attr_reader :originPostalCode, :originCountry, :destinationPostalCode, :destinationCountry,
              :totalCubicVolume, :cubicUnits, :pickupDateTime, :deliveryDateTime, :codAmount,
              :resultHash
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
  # Number of stackable pallets
  attr_accessor :numberStackablePallets
  # Shipment Type
  # Defaults to LTL with optional guaranteed returned
  #
  # ==== Acceptable Values
  # * *LTL* Standard LTL rate only returned
  # * *GTD* Guaranteed rate only returned
  # * *GTO* Expedited delivery rate returned (requires pickup and delivery date/time)
  attr_accessor :shipType
  # Insurance amount
  # Required for IND or INH accessorials
  attr_accessor :insuranceAmount
  # Number of Loose Pieces
  attr_accessor :loosePieces
  # Customer Email Address
  attr_accessor :email
  # Send email offers to customer
  # Defaults to false
  attr_accessor :sendEmailOffers
  # Customers first and last name
  attr_accessor :firstName, :lastName

  def initialize #:notnew: stops RDoc from seeing the initialize method
    @client = Savon.client(wsdl: 'https://www.odfl.com/wsRate_v3/services/Rate/wsdl/Rate.wsdl', ssl_verify_mode: :none,
                            log: true, log_level: :debug, pretty_print_xml: true)
    self.freight = Array.new
    self.accessorials = Array.new
    self.tariff = 559
    self.currencyFormat = "USD"
    self.requestReferenceNumber = false
    self.weightUnits = "LBS"
    self.sendEmailOffers = false
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
    if !self.accessorials.include?(accessorial)
      self.accessorials.push(accessorial)
    end
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

  # Set the pickup date and time
  # Required for Expedited GTO rates
  #
  # ==== Attributes
  # * +month+ Pickup/Delivery Month 1-12
  # * +day+ Pickup/Delivery Day 1-31
  # * +year+ Pickup/Delivery Year (4 digit year)
  # * +hour+ Pickup/Delivery Hour 0-23
  # * +minute+ Pickup/Delivery Minute 0-59
  # * +type+ The type of time to set either "pickup" or "delivery"
  #
  # ==== Usage
  #   quote = Odfl.new
  #   quote.setPickupDeliveryDateTime(12,25,2014,12,30, "delivery")
  def setPickupDeliveryDateTime(month, day, year, hour, minute, type)
    month = month<10 ? "0#{month}" : "#{month}"
    day = day<10 ? "0#{day}" : "#{day}"
    hour = hour<10 ? "0#{hour}" : "#{hour}"
    minute = minute<10 ? "0#{minute}" : "#{minute}"
    second = '00'
    if type == 'delivery'
      @deliveryDateTime = "#{year}-#{month}-#{day}T#{hour}:#{minute}:#{second}"
    else
      @pickupDateTime = "#{year}-#{month}-#{day}T#{hour}:#{minute}:#{second}"
    end
  end

  # Set an amount for COD
  # This will also automatically add the COD accessorial
  #
  # ==== Attributes
  # * *amount* The COD amount
  #
  # ==== Usage
  #   quote = Odfl.new
  #   quote.setCODAmount(100.53)
  def setCODAmount(amount)
    @codAmount = amount
    self.addAccessorial('COD')
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
                                                            cubicUnits: @cubicUnits,
                                                            numberStackablePallets: self.numberStackablePallets,
                                                            pickupDateTime: @pickupDateTime,
                                                            deliveryDateTime: @deliveryDateTime,
                                                            shipType: self.shipType,
                                                            codAmount: @codAmount,
                                                            insuranceAmount: self.insuranceAmount,
                                                            loosePieces: self.loosePieces,
                                                            email: self.email,
                                                            sendEmailOffers: self.sendEmailOffers,
                                                            firstName: self.firstName,
                                                            lastName: self.lastName
                                               })
    processResult(@response)
    
    if @resultHash[:success] == '1'
      true
    else
      false
    end
  end

  def get_estimate
    @resultHash[:rate_estimate]
  end

  def get_error
    @resultHash[:error_messages][:string]
  end

  private
  def processResult(result)
    @resultHash = result.to_hash[:my_rate_response]
  end
end
