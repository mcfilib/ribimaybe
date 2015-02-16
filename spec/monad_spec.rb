require "spec_helper"
include Ribimaybe::Maybe
describe "Monad Instance" do
  let(:id) do
    ->(x) { x }
  end

  let(:lifted_id) do
    ->(x) { id.(rturn(x)) }
  end

  let(:f) do
    ->(x){ ->(y) { rturn(x) } }.(SecureRandom.base64(1000))
  end

  let(:g) do
    ->(x){ ->(y) { rturn(x) } }.(SecureRandom.base64(1000))
  end

  [:bind, :>=].each do |m|
    # return a >>= f = f a
    describe "left identity" do
      context "when i have nothing" do
        it do
          expect(Nothing.public_send(m, &lifted_id)).to eq(Nothing)
        end
      end

      context "when i have just :x" do
        it do
          expect(rturn(:x).public_send(m, &lifted_id)).to eq(lifted_id.(:x))
        end
      end
    end

    # m >>= return = m
    describe "right identity" do
      context "when i have nothing" do
        it do
          expect(Nothing.public_send(m, &lifted_id)).to eq(Nothing)
        end
      end

      context "when i have just :x" do
        it do
          expect(Just(:x).public_send(m, &lifted_id)).to eq(Just(:x))
        end
      end
    end

    # (m >>= f) >>= g = m >>= (\x -> f x >>= g)
    describe "associativity" do
      context "when i have nothing" do
        it do
          lhs = Nothing.public_send(m, &f).public_send(m, &g)
          rhs = Nothing.bind { |x| f.(x).public_send(m, &g) }
          expect(lhs).to eq(rhs)
        end
      end

      context "when i have just :x" do
        it do
          lhs = Just(:x).public_send(m, &f).public_send(m, &g)
          rhs = Just(:x).bind { |x| f.(x).public_send(m, &g) }
          expect(lhs).to eq(rhs)
        end
      end
    end
  end
end
