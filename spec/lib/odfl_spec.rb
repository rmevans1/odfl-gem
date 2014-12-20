require 'spec_helper'

describe Odfl do

  it 'should set the origin zip code and country' do
    quote = Odfl.new
    quote.set_origin(29579)
    expect(quote).not_to be_nil
    expect(quote.originPostalCode).to eq(29579)
    expect(quote.originCountry).to eq('USA')
  end

  it 'should set the destination zip code and country' do
    quote = Odfl.new
    quote.set_destination(20602)
    expect(quote).not_to be_nil
    expect(quote.destinationPostalCode).to eq(20602)
    expect(quote.destinationCountry).to eq('USA')
  end

  it 'should set the movement of the shipment' do
    quote = Odfl.new
    quote.movement = 'O'
    expect(quote).not_to be_nil
    expect(quote.movement).to eq('O')
  end

  it 'should set the delivery date and time' do
    quote = Odfl.new
    quote.setPickupDeliveryDateTime(12,25,2014,12,30,'delivery')
    expect(quote).not_to be_nil
    expect(quote.deliveryDateTime).to eq('2014-12-25T12:30:00')
  end

  it 'should set the pickup date and time' do
    quote = Odfl.new
    quote.setPickupDeliveryDateTime(12,22,2014,12,30,'pickup')
    expect(quote).not_to be_nil
    expect(quote.pickupDateTime).to eq('2014-12-22T12:30:00')
  end

  it 'should add an accessorial' do
    quote = Odfl.new
    quote.addAccessorial('HYD')
    expect(quote).not_to be_nil
    expect(quote.accessorials.count).to eq(1)
  end

  it 'should not add a duplicate accessorial' do
    quote = Odfl.new
    quote.addAccessorial('HYD')
    expect(quote).not_to be_nil
    expect(quote.accessorials.count).to eq(1)
    quote.addAccessorial('HYD')
    expect(quote.accessorials.count).to eq(1)
  end

  it 'should set COD amount and add COD accessorial' do
    quote = Odfl.new
    quote.setCODAmount(1000.25)
    expect(quote).not_to be_nil
    expect(quote.codAmount).to eq(1000.25)
    expect(quote.accessorials.include?('COD')).to be_truthy
  end

  it 'should set cubic volume and cubic volume units' do
    quote = Odfl.new
    quote.setCubicVolume(100)
    expect(quote).not_to be_nil
    expect(quote.totalCubicVolume).to eq(100)
    expect(quote.cubicUnits).to eq('CF')
  end

  it 'should add a freight item' do
    quote = Odfl.new
    pallet = OdflFreight.new
    pallet.ratedClass = 70
    pallet.weight = 1000
    quote.addFreight(pallet.to_hash)
    expect(quote).not_to be_nil
    expect(quote.freight.count).to eq(1)
  end

  it 'should return false for an invalid quote' do
    quote = Odfl.new

    quote.set_destination(90210)
    result = quote.get_rates

    expect(quote).not_to be_nil
    expect(result).to be_falsey
  end

  it 'should return a valid rate estimate for a valid quote' do
    quote = Odfl.new

    quote.set_origin(20602)
    quote.set_destination(90210)

    pallet = OdflFreight.new
    pallet.ratedClass = 70
    pallet.weight = 1000
    quote.addFreight(pallet.to_hash)

    result = quote.get_rates
    expect(result).to be_truthy
    puts quote.resultHash
    rate = quote.get_estimate
    puts 'Estimate Below: '
    puts rate

    #expect(rate[:grossFreightCharge]).to be > 0
  end
end