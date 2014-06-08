# Ribimaybe

A tiny Ruby library that provides the Maybe datatype which is a Functor, 
Applicative Functor and Monad instance.

## Installation

Add this line to your application's Gemfile:

    gem 'ribimaybe'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ribimaybe

## Usage

### Functor

``` ruby
include Ribimaybe::Maybe

# Apply functions within Maybe and retain structure.
Just(42).map { |x| x * x } # => Just(1764)
Nothing.map  { |x| x * x } # => Nothing

# Pull a value out of Maybe.
Just(42).maybe(false) { |x| x == 42 } # => true
Nothing.maybe(false)  { |x| x == 42 } # => false 
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
