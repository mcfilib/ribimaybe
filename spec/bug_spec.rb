require "spec_helper"
include Ribimaybe::Maybe
describe "Bugs" do
  describe "issue17" do
    it do
      result = Just(1).bind{ |x|
        Nothing.bind{ |y|
          rturn(x + y)
        }
      }
      expect(result).to eq(Nothing)
    end
  end
end
