require "contracts"

module Ribimaybe
  module Maybe
    include Contracts

    module Nothing
      include Contracts

      # Nothing string representation.
      #
      def self.to_s
        "Nothing"
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

      def to_s
        "Just(#{@value.inspect})"
      end

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
      # * +_+  - Irrelevant default.
      # * +fn+ - Function to be applied inside our Just.
      #
      # ==== Examples
      #
      # Just(1).maybe(false) { |x| x == 1 } # => true
      # Just(1).maybe(42)    { |x| x }      # => 1
      #
      Contract Any, Proc => Any
      def maybe(_, &fn)
        fn.(@value)
      end

      # Applies fn to a value inside Just and re-wraps it in another Just.
      #
      # ==== Attributes
      #
      # * +fn+ - Function to be applied inside Just.
      #
      # ==== Examples
      #
      # Just(1).map { |x| x + 1 } # => Just(2)
      #
      Contract Proc => Just
      def map(&fn)
        Just.new(fn.(@value))
      end

      # Applies fn inside Just to a value in another Just and re-wraps the
      # result in another Just.
      #
      # ==== Attributes
      #
      # * +value+ - Maybe whose value will be use in function application.
      #
      # ==== Examples
      #
      # Just do |x|
      #   x + x
      # end.apply(Just(1)) # => Just(2)
      #
      Contract Or[Nothing, Just] => Or[Nothing, Just]
      def apply(value)
        value.map { |v| @value.(v) }
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
      Contract Proc => Just
      def bind(&fn)
        fn.(@value)
      end
    end

    # Converts nil to Nothing or lifts value into a Just. Pass either a block
    # or a function.
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
      (value || fn) ? Just(value || fn) : Nothing
    end

    # Wraps a value or a function in a Just or returns a Nothing.
    #
    # ==== Attributes
    #
    # * +value+ - Value to be wrapped.
    # * +fn+    - Block or function to be wrapped.
    #
    # ==== Examples
    #
    # Just(nil)      # => Nothing
    # Just(1)        # => Just(1)
    # Just { |x| x } # => Just(#<Proc:0x007fdecc03a478@(irb):6>)
    #
    Contract Any, Or[nil, Proc] => Or[Nothing, Just]
    def Just(value = nil, &fn)
      return Nothing unless (value || fn)
      Just.new(value || fn.curry)
    end

    # Wraps a value in a Just or returns a Nothing.
    #
    # ==== Attributes
    #
    # * +value+ - Value to be wrapped.
    #
    # ==== Examples
    #
    # pure(nil) # => Nothing
    # pure(1)   # => Just(1)
    #
    Contract Any => Or[Nothing, Just]
    def pure(value)
      Maybe(value)
    end

    # Wraps a value in a Just or returns a Nothing.
    #
    # ==== Attributes
    #
    # * +value+ - Value to be wrapped.
    #
    # ==== Examples
    #
    # rturn(nil) # => Nothing
    # rturn(1)   # => Just(1)
    #
    Contract Any => Or[Nothing, Just]
    def rturn(value)
      pure(value)
    end
  end
end
