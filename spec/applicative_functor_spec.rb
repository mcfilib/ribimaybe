require "spec_helper"
include Ribimaybe::Maybe
describe "Applicative Instance" do
  let(:ap) do
    ->(f, a){ f.(a) }.curry
  end

  let(:id) do
    ->(x){ x }
  end

  let(:dot) do
    ->(f, g){ ->(x){ f.(g.(x)) } }
  end

  let(:f) do
    ->(x){ ->(y) { x } }.(SecureRandom.base64(1000))
  end

  let(:g) do
    ->(x){ ->(y) { x } }.(SecureRandom.base64(1000))
  end

  # pure id <*> v = v
  describe "identity" do
    context "when i have nothing" do
      it do
        expect(pure(&id).apply(Nothing)).to eq(Nothing)
      end
    end

    context "when i have just :x" do
      it do
        expect(pure(&id).apply(pure(:x))).to eq(pure(:x))
      end
    end
  end

  # pure (.) <*> u <*> v <*> w = u <*> (v <*> w)
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
        lhs = pure(&dot).apply(pure(&f)).apply(pure(&g)).apply(pure(:x))
        rhs = pure(&f).apply(pure(&g).apply(pure(:x)))
        expect(lhs).to eq(rhs)
      end
    end
  end

  # pure f <*> pure x = pure (f x)
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

  # u <*> pure y = pure ($ y) <*> u
  describe "interchange" do
    context "when i have nothing" do
      it do
        expect(pure(&f).apply(Nothing)).to eq(pure(&ap.(f)).apply(Nothing))
      end
    end

    context "when i have just :x" do
      it do
        expect(pure(&f).apply(pure(:x))).to eq(pure(&ap.(f)).apply(pure(:x)))
      end
    end
  end

  # fmap f x = pure f <*> x
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
end
