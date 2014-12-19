require 'spec_helper'

describe Odfl do
  quote = Odfl.new

  it 'should set the origin zip code and country' do
    quote.set_origin(29579)
    expect(quote).not_to be_nil
    expect(quote.originPostalCode).to eq(29579)
    expect(quote.originCountry).to eq('USA')
  end

  it 'should set the destination zip code and country' do
    quote.set_destination(20602)
    expect(quote).not_to be_nil
    expect(quote.destinationPostalCode).to eq(20602)
    expect(quote.destinationCountry).to eq('USA')
  end

  it 'should set the movement of the shipment' do
    quote.movement = 'O'
    expect(quote).not_to be_nil
    expect(quote.movement).to eq('O')
  end

  it 'should set the delivery date and time' do
    quote.setPickupDeliveryDateTime(12,25,2014,12,30,'delivery')
    expect(quote).not_to be_nil
    expect(quote.deliveryDateTime).to eq('2014-12-25T12:30:00')
  end

  it 'should set the pickup date and time' do
    quote.setPickupDeliveryDateTime(12,22,2014,12,30,'pickup')
    expect(quote).not_to be_nil
    expect(quote.pickupDateTime).to eq('2014-12-22T12:30:00')
  end
end