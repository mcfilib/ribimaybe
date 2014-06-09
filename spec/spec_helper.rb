$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + "/../lib")

require "bundler/setup"
require "pry"
require "ribimaybe"
require "rubygems"

RSpec.configure do |config|
end

module Composable
  def compose(f, g)
    ->(*args){f.call(g.call(*args))}
  end

  def *(g)
    compose(self, g)
  end
end
