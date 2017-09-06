require 'watir'
require 'nokogiri'

require 'extensions/watir/browser'
require 'extensions/watir/element'
require 'extensions/watir/iframe'

require 'watigiri/locators/element/locator'
require 'watigiri/locators/element/selector_builder'

Watir.locator_namespace = Watigiri::Locators

# Use Watir Validator behaviors for all Elements
Watigiri::Locators::Element::Validator = Watir::Locators::Element::Validator
Watigiri::Locators::Button::Validator = Watir::Locators::Button::Validator
Watigiri::Locators::TextField::Validator = Watir::Locators::TextField::Validator

