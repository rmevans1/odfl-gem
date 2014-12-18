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

end