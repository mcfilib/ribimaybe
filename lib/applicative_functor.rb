module Ribimaybe
  module Maybe
    module Nothing
      Contract Any => Nothing
      def self.apply(_)
        self
      end
    end

    class Just
      Contract Or[Nothing, Just] => Or[Nothing, Just]
      def apply(value)
        value.map { |v| @value.curry.(v) }
      end
    end
  end
end
