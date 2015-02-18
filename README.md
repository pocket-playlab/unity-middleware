# Unity::Middleware

Unity's built-in http library does not always return response headers or status
codes. If the `X-Unity-Response` request header is set, this middleware wraps
the response status code, headers and body inside a json object in the response
body. It also sets the response status code to 200, as unity cannot handle
non-200 responses properly.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'unity-middleware'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install unity-middleware

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/pocket-playlab/unity-middleware/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
