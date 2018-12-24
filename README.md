# Watigiri

Watigiri is an extension gem to Watir that attempts to make it seamless for actions to be taken using Nokogiri 
instead of Selenium in the places it makes sense to do so.

The advantage of Nokogiri is that it parses the DOM very quickly. This provides two primary opportunities for speeding
 up Watir usage.
 
1. Obtaining multiple successive pieces of information about elements from a static DOM. For instance, to verify 
 that the text displayed on a page is the data that was previously entered into a form. Rather than making several
 dozen wire calls to locate and obtain text information from each, you can make one wire call to obtain the DOM and then 
 quickly locate and obtain all of the information necessary at each element location.
  
2. Iterating over a collection of elements to match a regular expression. 
Watir implements this by locating a subset of elements that might match and then making wire calls
on each to check if they actually match the provided regular expression. 
If the number of elements to be checked is large, using Nokogiri can show a significant performance improvement.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'watigiri'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install watigiri

## Usage

First require it in your code:
```ruby
require 'watigiri'
```

Once required, Watigiri will automatically speed up the location of elements using regular expression values.
If you would like to turn this feature off, you can set: `Watigiri.match_regexp = false`

To speed up the gathering of text values, use the text-bang method (`Element#text!` instead of `Element#text`).
Watigiri flushes the cached DOM whenever a user takes an action that might have changed the DOM 
(clicks, navigations, etc).
So the performance improvement will be based on the number of successive calls of `#text!` 
before taking other actions. 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/titusfortner/watigiri.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
