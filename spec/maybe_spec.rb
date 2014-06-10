require "spec_helper"
include Ribimaybe::Maybe
describe Ribimaybe::Maybe do
  describe ".maybe" do
    context "when i have nothing" do
      it "should give me back a default" do
        expect(Nothing.maybe(false) { |_| true }).to eq(false)
      end
    end
  end

  describe "#maybe" do
    context "when i have something" do
      it "should give me back something" do
        expect(Just(:x).maybe(:y) { |x| x }).to eq(:x)
      end
    end
  end

  describe "#Maybe()" do
    context "when i have nil" do
      it "should give me back nothing" do
        expect(Maybe(nil)).to eq(Nothing)
      end
    end

    context "when i have :x" do
      it "should give me back just :x" do
        expect(Maybe(:x)).to eq(Just(:x))
      end
    end
  end
end
