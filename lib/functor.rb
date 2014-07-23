module Ribimaybe
  module Maybe
    module Nothing
      Contract Proc => Nothing
      def self.map(&_)
        self
      end
    end

    class Just
      Contract Proc => Just
      def map(&fn)
        Just.new(fn.curry.(@value))
      end
    end
  end
end
