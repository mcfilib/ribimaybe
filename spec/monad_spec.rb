require "spec_helper"
include Ribimaybe::Maybe
describe "Monad Instance" do
  let(:f) do
    ->(x){ ->(y) { rturn(x) } }.(SecureRandom.base64(1000))
  end

  let(:g) do
    ->(x){ ->(y) { rturn(x) } }.(SecureRandom.base64(1000))
  end

  # return a >>= f = f a
  describe "left identity" do
    context "when i have nothing" do
      it do
        expect(Nothing.bind(&f)).to eq(Nothing)
      end
    end

    context "when i have just :x" do
      it do
        expect(rturn(:x).bind(&f)).to eq(f.(:a))
      end
    end
  end

  # m >>= return = m
  describe "right identity" do
    context "when i have nothing" do
      it do
        expect(Nothing.bind { |x| rturn(x) }).to eq(Nothing)
      end
    end

    context "when i have just :x" do
      it do
        expect(Just(:x).bind { |x| rturn(x) }).to eq(Just(:x))
      end
    end
  end

  # (m >>= f) >>= g = m >>= (\x -> f x >>= g)
  describe "associativity" do
    context "when i have nothing" do
      it do
        lhs = Nothing.bind(&f).bind(&g)
        rhs = Nothing.bind { |x| f.(x).bind(&g) }
        expect(lhs).to eq(rhs)
      end
    end

    context "when i have just :x" do
      it do
        lhs = Just(:x).bind(&f).bind(&g)
        rhs = Just(:x).bind { |x| f.(x).bind(&g) }
        expect(lhs).to eq(rhs)
      end
    end
  end
end
