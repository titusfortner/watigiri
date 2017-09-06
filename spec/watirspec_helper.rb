require 'watirspec'
require 'watigiri'
require 'webdrivers'

WatirSpec.implementation do |watirspec|
  opts = {}

  watirspec.name = :watigiri
  watirspec.browser_class = Watir::Browser
  watirspec.browser_args = [:chrome, opts]

  watirspec.guard_proc = lambda do |watirspec_guards|
    watigiri_guards = %i(chrome watigiri relaxed_locate)
    watirspec_guards.any? { |guard| watigiri_guards.include?(guard) }
  end
end

WatirSpec.run!
