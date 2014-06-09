require "spec_helper"
include Ribimaybe::Maybe

describe "Functor Instance" do

  let(:id) do
    ->(x){ x }
  end

  let(:f) do
    ->(x){ ->(y) { x } }.(SecureRandom.base64(1000)).extend(Composable)
  end

  let(:g) do
    ->(x){ ->(y) { x } }.(SecureRandom.base64(1000)).extend(Composable)
  end

  describe "identity" do
    context "when i have nothing" do
      it "should give me back nothing" do
        expect(Nothing.map(&id)).to eq(Nothing)
      end
    end

    context "when i have just :x" do
      it "should give me back just :x" do
        expect(Just(:x).map(&id)).to eq(Just(:x))
      end
    end
  end

  describe "composition" do
    context "when i have nothing" do
      it "should be closed under composition" do
        expect(Nothing.map(&(f * g))).to eq(Nothing.map(&g).map(&f))
      end
    end

    context "when i have just :x" do
      it "should be closed under composition" do
        expect(Just(:x).map(&(f * g))).to eq(Just(:x).map(&g).map(&f))
      end
    end
  end

  describe "#map" do
    context "when i have nothing" do
      it "should give me back nothing" do
        result = Nothing.map { |x| x + 1 }
        expect(result).to eq Nothing
      end
    end

    context "when i have something" do
      it "should apply the fn and we-wrap the value" do
        result = Just(41).map { |x| x + 1 }
        expect(result).to eq Just(42)
      end
    end
  end
end
