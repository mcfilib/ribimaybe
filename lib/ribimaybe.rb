module Ribimaybe
  VERSION = "0.0.1"

  module Maybe
    class Nothing
      def self.maybe(default, &fn)
        default
      end

      def self.to_s
        "Nothing"
      end
    end

    class Just
      def initialize(value)
        @value = value
      end

      def maybe(default, &fn)
        fn.(@value)
      end

      def to_s
        "Just(#{@value.inspect})"
      end

      def ==(other)
        other.maybe(false) do |value|
          @value == value
        end
      end
    end

    def Maybe(value)
      value ? Just.new(value) : Nothing
    end
  end

  module Maybe
    class Nothing
      def self.map(&fn)
        self
      end
    end

    class Just
      def map(&fn)
        Just.new(fn.(@value))
      end
    end
  end

  module Maybe
    class Nothing
      def self.apply(value)
        self
      end
    end

    class Just
      def apply(value)
        value.map { |v| @value.(v) }
      end
    end

    def pure(value)
      Maybe(value)
    end
  end

  module Maybe
    class Nothing
      def self.bind(&fn)
        self
      end
    end

    class Just
      def bind(&fn)
        fn.(@value)
      end
    end

    def rturn(value)
      pure(value)
    end
  end
end
