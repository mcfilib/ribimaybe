require "spec_helper"
include Ribimaybe::Maybe

describe Ribimaybe::Maybe do
  describe ".maybe" do
    context "when i have nothing" do
      it "should give me back a default" do
        result = Nothing.maybe(42) { |x| x + 1 }
        expect(result).to eq 42
      end
    end

    context "when i have something" do
      it "should give me back something" do
        result = Just(42).maybe(1) { |x| x }
        expect(result).to eq 42
      end
    end
  end
end
