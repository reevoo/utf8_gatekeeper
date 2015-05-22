# UTF8Gatekeeper

Returns a 400 error when there are invalid UTF-8 characters in the environment so that your app doesn't choke
on them. This prevents errors like "invalid byte sequence in UTF-8".

## Installation

Add this line to your application's Gemfile:

```ruby
# Gemfile
gem 'utf8_gatekeeper'
```

And then execute:

```
bundle
```

Or install it yourself as:

```
gem install utf8_gatekeeper
```

If you're not running Rails, you'll have to add the middleware to your config.ru:

```ruby
# config.ru
require 'utf8_gatekeeper'
use UTF8Gatekeeper::Middleware
```

## Usage

There's nothing to "use". It just works!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

Forked from [singlebrook's](https://github.com/singlebrook)
[utf8-cleaner](https://github.com/singlebrook/utf8-cleaner).

Original middleware author: [phoet](https://github.com/phoet) -
[gist.github.com/phoet/1336754](https://gist.github.com/phoet/1336754)

* Ruby 1.9.3 compatibility: [pithyless](https://github.com/pithyless) -
  [gist.github.com/pithyless/3639014](https://gist.github.com/pithyless/3639014)
* Code review and cleanup: [nextmat](https://github.com/nextmat)
* POST body sanitization: [salrepe](https://github.com/salrepe)
