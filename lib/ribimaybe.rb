require "contracts"
require "types"
require "base"
require "functor"
require "applicative_functor"
require "monad"

module Ribimaybe
  module Maybe
    include Contracts

    Contract Any, Or[nil, Proc] => Or[Nothing, Just]
    def Maybe(value = nil, &fn)
      (value || fn) ? Just.new(value || fn.curry) : Nothing
    end

    alias_method :Just,  :Maybe
    alias_method :pure,  :Maybe
    alias_method :rturn, :Maybe
  end
end
