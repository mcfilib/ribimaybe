require "spec_helper"
include Ribimaybe::Maybe
describe "Bugs" do
  describe "issue17" do
    it do
      result = Just(1).bind{ |x|
        Nothing.bind{ |y|
          lift(x + y)
        }
      }
      expect(result).to eq(Nothing)
    end
  end

  describe "issue19" do
    context "when i have nothing" do
      it do
        x = Nothing
        result = case x
                 when Just
                   x.maybe(:x) { |x| x }
                 when Nothing
                   :nothing
                 end
        expect(result).to eq(:nothing)
      end
    end

    context "when i have just :x" do
      it do
        x = Just(:x)
        result = case x
                 when Just
                   x.maybe(:x) { |x| x }
                 when Nothing
                   :nothing
                 end
        expect(result).to eq(:x)
      end
    end
  end
end
