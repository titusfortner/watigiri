require 'watir'
require 'nokogiri'

require 'extensions/watir/browser'
require 'extensions/watir/element'

require 'watigiri/locators/element/locator'
require 'watigiri/locators/element/matcher'

module Watigiri
  @match_regexp = true

  class << self
    attr_writer :match_regexp

    def match_regexp?
      @match_regexp
    end
  end
end
