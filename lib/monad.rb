module Ribimaybe
  module Maybe
    module Nothing
      Contract Proc => Nothing
      def self.bind(&_)
        self
      end
    end

    class Just
      Contract Proc => Or[Nothing, Just]
      def bind(&fn)
        fn.curry.(@value)
      end
    end
  end
end
