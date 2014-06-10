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

  # fmap id = id
  describe "identity" do
    context "when i have nothing" do
      it do
        expect(Nothing.map(&id)).to eq(Nothing)
      end
    end

    context "when i have just :x" do
      it do
        expect(Just(:x).map(&id)).to eq(Just(:x))
      end
    end
  end

  # fmap (f . g) = fmap f . fmap g
  describe "composition" do
    context "when i have nothing" do
      it do
        expect(Nothing.map(&(f * g))).to eq(Nothing.map(&g).map(&f))
      end
    end

    context "when i have just :x" do
      it do
        expect(Just(:x).map(&(f * g))).to eq(Just(:x).map(&g).map(&f))
      end
    end
  end
end
