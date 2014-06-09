require "spec_helper"
include Ribimaybe::Maybe

describe "Applicative Instance" do

  let(:id) do
    ->(x){ x }
  end

  let(:dot) do
    ->(f, g){ ->(x){ f.(g.(x)) } }
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
        expect(pure(&id).apply(Nothing)).to eq(Nothing)
      end
    end

    context "when i have just :x" do
      it "should give me back just :x" do
        expect(pure(&id).apply(Just(:x))).to eq(Just(:x))
      end
    end
  end

  describe "composition" do
    context "when i have nothing" do
      it do
        lhs = pure(&dot).apply(pure(&f)).apply(pure(&g)).apply(Nothing)
        rhs = pure(&f).apply(pure(&g).apply(Nothing))
        expect(lhs).to eq(rhs)
      end
    end

    context "when i have just :x" do
      it do
        lhs = pure(&dot).apply(pure(&f)).apply(pure(&g)).apply(Just(:x))
        rhs = pure(&f).apply(pure(&g).apply(Just(:x)))
        expect(lhs).to eq(rhs)
      end
    end
  end

  describe "homomorphism" do
    context "when i have nothing" do
      it do
        expect(pure(&f).apply(Nothing)).to eq(Nothing)
      end
    end

    context "when i have just :x" do
      it do
        expect(pure(&f).apply(pure(:x))).to eq(pure(f.(:x)))
      end
    end
  end

  describe "interchange" do
    context "when i have nothing" do
      it do
      end
    end

    context "when i have just :x" do
      it do
      end
    end
  end

  describe "map" do
    context "when i have nothing" do
      it do
        expect(Nothing.map(&f)).to eq(pure(&f).apply(Nothing))
      end
    end

    context "when i have just :x" do
      it do
        expect(Just(:x).map(&f)).to eq(pure(&f).apply(Just(:x)))
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
