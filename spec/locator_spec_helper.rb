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

    def doc
      doc = instance_double Nokogiri::HTML::Document
      allow(doc).to receive(:at_xpath).with(@xpath).and_return(element)
      doc
    end

    def se_element
      @se_element ||= instance_double Selenium::WebDriver::Element
      allow(@se_element).to receive(:displayed?).and_return(true)
      allow(@se_element).to receive(:is_a?).with(Selenium::WebDriver::Element).and_return(true)
      @se_element
    end

    def watir_element
      watir_element = instance_double(Watir::HTMLElement)
      expect(watir_element).to receive(:doc).and_return(nil, doc)
      expect(watir_element).to receive(:doc=).with(instance_of(Nokogiri::HTML::Document))
      watir_element
    end
  end
end
