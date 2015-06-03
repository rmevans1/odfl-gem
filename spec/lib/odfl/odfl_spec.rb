require 'spec_helper'

module Odfl
  describe Shipment do
    context "missing required parameters" do
      it "should raise Rate exception" do
        expect{ Shipment.new }.to raise_error(RateError)
      end
    end
  end
end
