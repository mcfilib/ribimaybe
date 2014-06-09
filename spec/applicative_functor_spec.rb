require "spec_helper"
include Ribimaybe::Maybe

describe "Applicative Instance" do

 #  pure id <*> v = v                            -- Identity
 #  pure (.) <*> u <*> v <*> w = u <*> (v <*> w) -- Composition
 #  pure f <*> pure x = pure (f x)               -- Homomorphism
 #  u <*> pure y = pure ($ y) <*> u              -- Interchange

  let(:id) do
    ->(x){ x }
  end

  let(:f) do
    ->(y){ :y }.extend(Composable)
  end

  let(:g) do
    ->(x){ :x }.extend(Composable)
  end

  describe "identity" do
    context "when i have nothing" do
      it "should give me back nothing" do
        expect(pure(&id).apply(Nothing)).to eq(Nothing)
      end
    end

    context "when i have just :x" do
      it "should give me back just :x" do
        expect(pure(&id).apply(Just(:x))).to eq(Just(:x))
      end
    end
  end

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
        result = pure do |x|
          x + x
        end.apply Just(21)
        expect(result).to eq Just(42)
      end

      it "should be curried by default" do
        result = pure do |x, y|
          x + y
        end.apply(Just(21)).apply(Just(21))
        expect(result).to eq Just(42)
      end
    end
  end
end
