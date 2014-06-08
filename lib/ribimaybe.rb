require "contracts"

module Ribimaybe
  VERSION = "0.0.1"

  module Maybe
    class Nothing
      include Contracts
      Contract Any, Proc => Any
      def self.maybe(default, &fn)
        default
      end

      Contract nil => String
      def self.to_s
        "Nothing"
      end

      # Contract Proc => Nothing
      def self.map(&fn)
        Nothing
      end

      # Contract Or[Nothing, Just] => Nothing
      def self.apply(value)
        Nothing
      end

      # Contract Or[Nothing, Just] => Nothing
      def self.bind(&fn)
        Nothing
      end
    end

    class Just
      include Contracts
      def initialize(value)
        @value = value
      end

      Contract Any, Proc => Any
      def maybe(default, &fn)
        fn.(@value)
      end

      Contract nil => String
      def to_s
        "Just(#{@value.inspect})"
      end

      Contract Or[Nothing, Just] => Bool
      def ==(other)
        other.maybe(false) do |value|
          @value == value
        end
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

    def Maybe(value = nil, &fn)
      value ? Just(value || fn) : Nothing
    end

    def Just(value = nil, &fn)
      return Nothing unless (value || fn)
      Just.new(value || fn)
    end

    def pure(value)
      Maybe(value)
    end

    def rturn(value)
      pure(value)
    end
  end
end
