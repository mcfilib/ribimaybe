require "contracts"

module Ribimaybe
  VERSION = "0.0.1"

  module Maybe
    include Contracts

    module Nothing
      include Contracts

      Contract Any, Proc => Any
      def self.maybe(default, &fn)
        default
      end

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
      include Contracts

      def initialize(value)
        @value = value
      end

      def to_s
        "Just(#{@value.inspect})"
      end

      Contract Or[Nothing, Just] => Bool
      def ==(other)
        other.maybe(false) do |value|
          @value == value
        end
      end

      Contract Any, Proc => Any
      def maybe(_, &fn)
        fn.(@value)
      end

      Contract Proc => Just
      def map(&fn)
        Just.new(fn.(@value))
      end

      Contract Or[Nothing, Just] => Or[Nothing, Just]
      def apply(value)
        value.map { |v| @value.(v) }
      end

      Contract Proc => Just
      def bind(&fn)
        fn.(@value)
      end
    end

    Contract Any, Or[nil, Proc] => Or[Nothing, Just]
    def Maybe(value = nil, &fn)
      value ? Just(value || fn) : Nothing
    end

    Contract Any, Or[nil, Proc] => Or[Nothing, Just]
    def Just(value = nil, &fn)
      return Nothing unless (value || fn)
      Just.new(value || fn)
    end

    Contract Any => Or[Nothing, Just]
    def pure(value)
      Maybe(value)
    end

    Contract Any => Or[Nothing, Just]
    def rturn(value)
      pure(value)
    end
  end
end
