require "spec_helper"
include Ribimaybe::Maybe

describe "Monad Instance" do
  describe "#rturn" do
    context "when i provide a nil" do
      it "should give me back nothing" do
        result = rturn(nil)
        expect(result).to eq Nothing
      end
    end

    context "when i provide a value" do
      it "should wrap the value" do
        result = rturn(42)
        expect(result).to eq Just(42)
      end
    end
  end

  describe "#bind" do
    context "when i have nothing" do
      it "should give me back nothing" do
        result = Nothing.bind do |x|
          rturn x + x
        end
        expect(result).to eq Nothing
      end
    end

    context "when i something containing a fn" do
      it "should be apply to apply that fn to something" do
        result = Just(21).bind do |x|
          rturn x + x
        end
        expect(result).to eq Just(42)
      end
    end
  end
end
