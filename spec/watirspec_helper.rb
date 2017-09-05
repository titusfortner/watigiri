require 'watirspec'
require 'watigiri'
require 'webdrivers'

WatirSpec.implementation do |watirspec|
  opts = {}

  watirspec.name = :watigiri
  watirspec.browser_class = Watir::Browser
  watirspec.browser_args = [:chrome, opts]
end

WatirSpec.run!
