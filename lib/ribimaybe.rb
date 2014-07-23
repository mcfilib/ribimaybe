require "contracts"

module Ribimaybe
  module Maybe
    include Contracts

    module Nothing
    end

    class Just
    end

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

    module Nothing
      Contract Proc => Nothing
      def self.map(&_)
        self
      end

      Contract Any => Nothing
      def self.apply(_)
        self
      end

      Contract Proc => Nothing
      def self.bind(&_)
        self
      end
    end

    class Just
      Contract Proc => Just
      def map(&fn)
        Just.new(fn.curry.(@value))
      end

      Contract Or[Nothing, Just] => Or[Nothing, Just]
      def apply(value)
        value.map { |v| @value.curry.(v) }
      end

      Contract Proc => Or[Nothing, Just]
      def bind(&fn)
        fn.curry.(@value)
      end
    end

    Contract Any, Or[nil, Proc] => Or[Nothing, Just]
    def Maybe(value = nil, &fn)
      (value || fn) ? Just.new(value || fn.curry) : Nothing
    end

    alias_method :Just,  :Maybe
    alias_method :pure,  :Maybe
    alias_method :rturn, :Maybe
  end
end
