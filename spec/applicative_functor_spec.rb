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

  [:apply, :>>].each do |m|
    # pure id <*> v = v
    describe "identity" do
      context "when i have nothing" do
        it do
          expect(pure(&id).public_send(m, Nothing)).to eq(Nothing)
        end
      end

      context "when i have just :x" do
        it do
          expect(pure(&id).public_send(m, pure(:x))).to eq(pure(:x))
        end
      end
    end

    # pure (.) <*> u <*> v <*> w = u <*> (v <*> w)
    describe "composition" do
      context "when i have nothing" do
        it do
          lhs = pure(&dot).public_send(m, pure(&f)).public_send(m, pure(&g)).public_send(m, Nothing)
          rhs = pure(&f).public_send(m, pure(&g).public_send(m, Nothing))
          expect(lhs).to eq(rhs)
        end
      end

      context "when i have just :x" do
        it do
          lhs = pure(&dot).public_send(m, pure(&f)).public_send(m, pure(&g)).public_send(m, pure(:x))
          rhs = pure(&f).public_send(m, pure(&g).public_send(m, pure(:x)))
          expect(lhs).to eq(rhs)
        end
      end
    end

    # pure f <*> pure x = pure (f x)
    describe "homomorphism" do
      context "when i have nothing" do
        it do
          expect(pure(&f).public_send(m, Nothing)).to eq(Nothing)
        end
      end

      context "when i have just :x" do
        it do
          expect(pure(&f).public_send(m, pure(:x))).to eq(pure(f.(:x)))
        end
      end
    end

    # u <*> pure y = pure ($ y) <*> u
    describe "interchange" do
      context "when i have nothing" do
        it do
          expect(pure(&f).public_send(m, Nothing)).to eq(pure(&ap.(f)).public_send(m, Nothing))
        end
      end

      context "when i have just :x" do
        it do
          expect(pure(&f).public_send(m, pure(:x))).to eq(pure(&ap.(f)).public_send(m, pure(:x)))
        end
      end
    end

    # fmap f x = pure f <*> x
    describe "map" do
      context "when i have nothing" do
        it do
          expect(Nothing.map(&f)).to eq(pure(&f).public_send(m, Nothing))
        end
      end

      context "when i have just :x" do
        it do
          expect(Just(:x).map(&f)).to eq(pure(&f).public_send(m, Just(:x)))
        end
      end
    end
  end

  describe "variadic apply" do
    context "when i have :x and :y" do
      it do
        expect(Just { |x, y| [x,y] }.apply(pure(:x), pure(:y))).to eq Just([:x, :y])
      end
    end
  end
end
