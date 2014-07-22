require "contracts"

module Ribimaybe
  module Maybe
    include Contracts

    # Hack to ensure constant is available to Ruby contracts.
    #
    module Nothing; end
    class  Just;    end

    module Nothing
      include Contracts

      # Nothing string representation.
      #
      def self.to_s
        "Nothing"
      end

      alias_method :inspect, :to_s

      # Compares a Nothing to another Maybe.
      #
      # ==== Attributes
      #
      Contract Or[Nothing, Just] => Bool
      def self.===(other)
        self == other
      end

      # No operation. Always returns the default value.
      #
      Contract Any, Proc => Any
      def self.maybe(default, &_)
        default
      end

      # No operation. Always returns Nothing.
      #
      Contract Proc => Nothing
      def self.map(&_)
        self
      end

      # No operation. Always returns Nothing.
      #
      Contract Any => Nothing
      def self.apply(_)
        self
      end

      # No operation. Always returns Nothing.
      #
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

      # Just string representation.
      #
      def to_s
        "Just(#{@value.inspect})"
      end

      alias_method :inspect, :to_s

      # Compares a Just to another Maybe.
      #
      # ==== Attributes
      #
      # * +other+ - The other Maybe value.
      #
      # ==== Examples
      #
      # Just(1) == Just(1) # => true
      # Just(1) == Just(2) # => false
      # Just(1) == Nothing # => false
      #
      Contract Or[Nothing, Just] => Bool
      def ==(other)
        other.maybe(false) do |value|
          @value == value
        end
      end

      # Fetches a value out of a Just and returns the application
      # of fn to the internal value.
      #
      # ==== Attributes
      #
      # * +_+  - Default value that's never used.
      # * +fn+ - Function to be applied to value inside Just.
      #
      # ==== Examples
      #
      # Just(1).maybe(false) { |x| x == 1 } # => true
      # Just(1).maybe(42)    { |x| x }      # => 1
      #
      Contract Any, Proc => Any
      def maybe(_, &fn)
        fn.curry.(@value)
      end

      # Applies fn to a value inside Just and re-wraps it in another Just.
      #
      # ==== Attributes
      #
      # * +fn+ - Function to be applied inside Just.
      #
      # ==== Examples
      #
      # Just(1).map { |x| x + 1 }               # => Just(2)
      # Just { |x, y| x + y }.map { |f| f.(1) } # => Just(#<Proc:...>)
      #
      Contract Proc => Just
      def map(&fn)
        Just.new(fn.curry.(@value))
      end

      # Applies fn inside Just to a value in a Just and re-wraps the result in
      # a Just. Note that functions are curried by default.
      #
      # ==== Attributes
      #
      # * +value+ - Maybe value.
      #
      # ==== Examples
      #
      # Just do |x|
      #   x + x
      # end.apply(Just(1)) # => Just(2)
      #
      Contract Or[Nothing, Just] => Or[Nothing, Just]
      def apply(value)
        value.map { |v| @value.curry.(v) }
      end

      # Applies fn to value inside Just (note contract constraint).
      #
      # ==== Attributes
      #
      # * +fn+ - Function to be applied inside our Just.
      #
      # ==== Examples
      #
      # Just(1).bind do |x|
      #   rturn(x + x)
      # end # => Just(2)
      #
      Contract Proc => Or[Nothing, Just]
      def bind(&fn)
        fn.curry.(@value)
      end
    end

    # Converts nil to Nothing or lifts value into a Just. Accepts a optional
    # block or value.
    #
    # ==== Attributes
    #
    # * +value+ - Value to be wrapped.
    # * +fn+    - Block or function to be wrapped.
    #
    # ==== Examples
    #
    # Maybe(nil)      # => Nothing
    # Maybe(1)        # => Just(1)
    # Maybe { |x| x } # => Just(#<Proc:0x007fdecc03a478@(irb):6>)
    #
    Contract Any, Or[nil, Proc] => Or[Nothing, Just]
    def Maybe(value = nil, &fn)
      (value || fn) ? Just.new(value || fn.curry) : Nothing
    end

    alias_method :Just,  :Maybe
    alias_method :pure,  :Maybe
    alias_method :rturn, :Maybe
  end
end
