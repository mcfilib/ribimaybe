require "spec_helper"
include Ribimaybe::Maybe

describe "Functor Instance" do

  let(:nothing) do
    Nothing
  end

  let(:something) do
    Just.new(41)
  end

  describe "#map" do
    context "when i have nothing" do
      it "should give me back nothing" do
        result = nothing.map { |x| x + 1 }
        expect(result).to eq(Nothing)
      end
    end

    context "when i have something" do
      it "should apply the fn and we-wrap the value" do
        result = something.map { |x| x + 1 }
        expect(result).to eq(Just.new(42))
      end
    end
  end
end
