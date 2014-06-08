require "spec_helper"
include Ribimaybe::Maybe

describe "Applicative Instance" do
  describe "#pure" do
    context "when i provide a nil" do
      it "should give me back nothing" do
        result = pure(nil)
        expect(result).to eq Nothing
      end
    end

    context "when i provide a value" do
      it "should wrap the value" do
        result = pure(42)
        expect(result).to eq Just(42)
      end
    end
  end

  describe "#apply" do
    context "when i have nothing" do
      it "should give me back nothing" do
        result = Nothing.apply Just(42)
        expect(result).to eq Nothing
      end
    end

    context "when i something containing a fn" do
      it "should be apply to apply that fn to something" do
        result = Just do |x|
          x + x
        end.apply Just(21)
        expect(result).to eq Just(42)
      end
    end
  end
end
