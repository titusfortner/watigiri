require 'watir'

module Watigiri
  module LocatorSpecHelper
    def driver
      @driver ||= instance_double(Selenium::WebDriver::Driver)
    end

    def browser
      @browser ||= instance_double(Watir::Browser)
      allow(@browser).to receive(:is_a?).with(Watir::Browser).and_return(true)
      allow(@browser).to receive(:doc).and_return(nil, doc)
      allow(@browser).to receive(:doc=).with(instance_of(Nokogiri::HTML::Document))
      allow(@browser).to receive(:browser).and_return(@browser)
      allow(@browser).to receive(:wd).and_return(driver)
      @browser
    end

    def se_element
      element = instance_double Selenium::WebDriver::Element
      allow(element).to receive(:displayed?).and_return(true)
      allow(element).to receive(:is_a?).with(Selenium::WebDriver::Element).and_return(true)
      element
    end

    def watir_element
      element = instance_double(Watir::HTMLElement)
      allow(element).to receive(:wd).and_return(se_element)
      allow(element).to receive(:doc).and_return(nil, doc)
      allow(element).to receive(:doc=).with(instance_of(Nokogiri::HTML::Document))
      element
    end
  end
end
