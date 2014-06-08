require "spec_helper"
include Ribimaybe::Maybe

describe "Functor Instance" do

  describe "#map" do
    context "when i have nothing" do
      it "should give me back nothing" do
        result = Nothing.map { |x| x + 1 }
        expect(result).to eq Nothing
      end
    end

    context "when i have something" do
      it "should apply the fn and we-wrap the value" do
        result = Just.new(41).map { |x| x + 1 }
        expect(result).to eq Just.new(42)
      end
    end
  end

end
