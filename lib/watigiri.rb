require 'watir'
require 'nokogiri'

require 'extensions/watir/browser'
require 'extensions/watir/element'
require 'extensions/watir/iframe'

require 'watigiri/locators/element/locator'
require 'watigiri/locators/element/selector_builder'
require 'watigiri/locators/element/validator'

Watir.locator_namespace = Watigiri::Locators

Watigiri::Locators::Button    = Watir::Locators::Button
Watigiri::Locators::Cell      = Watir::Locators::Cell
Watigiri::Locators::Row       = Watir::Locators::Row
Watigiri::Locators::TextArea  = Watir::Locators::TextArea
Watigiri::Locators::TextField = Watir::Locators::TextField
