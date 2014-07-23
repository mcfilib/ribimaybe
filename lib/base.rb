module Ribimaybe
  module Maybe
    module Nothing
      include Contracts

      def self.to_s
        "Nothing"
      end

      Contract Any, Proc => Any
      def self.maybe(default, &_)
        default
      end

      Contract Or[Nothing, Just] => Bool
      def self.===(other)
        self == other
      end

      alias_method :inspect, :to_s
    end

    class Just
      include Contracts

      def initialize(value)
        @value = value
      end

      def to_s
        "Just(#{@value.inspect})"
      end

      Contract Any, Proc => Any
      def maybe(_, &fn)
        fn.curry.(@value)
      end

      Contract Or[Nothing, Just] => Bool
      def ==(other)
        other.maybe(false) do |value|
          @value == value
        end
      end

      alias_method :inspect, :to_s
    end
  end
end
