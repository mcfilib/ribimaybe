# Ribimaybe

> "Flavouring the ocean with a teaspoon of sugar."

[![Gem Version](https://badge.fury.io/rb/ribimaybe.svg)](http://badge.fury.io/rb/ribimaybe)
[![Travis](https://travis-ci.org/filib/ribimaybe.svg?branch=master)](http://travis-ci.org/filib/ribimaybe)
[![Code Climate](https://codeclimate.com/github/unsymbol/ribimaybe.png)](https://codeclimate.com/github/unsymbol/ribimaybe)

![](maybe.gif)

A tiny Ruby library that provides a Maybe datatype which is a Functor,
Applicative Functor and Monad.

## Installation

Add this line to your application's Gemfile:

    gem 'ribimaybe'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ribimaybe

## Usage

This is a small library and so it doesn't offer lots of creature comforts. The
one escape hatch it does offer is the ability to convert `nil` into `Nothing`.

``` ruby
include Ribimaybe::Maybe

Maybe(42)  # => Just(42)
Maybe(nil) # => Nothing
```

And that's it, once you have lifted your value into a `Maybe` you can treat it
as a `Functor`, `Applicative Functor` or `Monad`. If you want to pull your value
out of a `Maybe`, we got you covered too.

``` ruby
Just(42).maybe(false) { |x| x == 42 } # => true
Nothing.maybe(false)  { |x| x == 42 } # => false
```

### Functor [\[info\]](http://learnyouahaskell.com/functors-applicative-functors-and-monoids)

``` ruby
include Ribimaybe::Maybe

# Apply functions within Maybe and retain structure.
Just(42).map { |x| x * x } # => Just(1764)
Nothing.map  { |x| x * x } # => Nothing
```

### Applicative Functor [\[info\]](http://learnyouahaskell.com/functors-applicative-functors-and-monoids)

``` ruby
include Ribimaybe::Maybe

# Wrap functions inside functors and apply them to other functors!
Just do |x, y|
  x * y
end.apply(pure(42)).apply(pure(42)) # => Just(1764)

Just do |x|
  x * x
end.apply(Nothing) # => Nothing

# We can't define <*> but we can define a different operator with the same
# semantics!
Just { |x, y| x * y } >> pure(42) >> pure(42) # => Just(1764)
```

### Monad [\[info\]](http://www.learnyouahaskell.com/a-fistful-of-monads)

``` ruby
include Ribimaybe::Maybe

# Chain together computations and pretend you're a Haskeller.
Just(42).bind do |x|
  lift(x - 21).bind do |y|
    if x * x > 100 then lift(x) else lift(y) end
  end
end # => Just(42)

# You guessed it! If have Nothing, you get Nothing.
Nothing.bind do |x|
  lift(x * x)
end # => Nothing

# We even have >= but you need to pass a Proc or a lambda.
Just(42) >= -> (x) do
  lift(x - 21) >= -> (y) do
    if x * x > 100 then lift(x) else lift(y) end
  end
end # => Just(42)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
