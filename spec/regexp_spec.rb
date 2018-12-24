require 'watirspec_helper'
require 'locator_spec_helper'

module Watigiri
  describe Locators::Element::Locator do
    include LocatorSpecHelper

    let(:matcher) { Locators::Element::Matcher.new(@query_scope || browser) }
    let(:locator) { described_class.new(matcher) }

    let(:nokogiri_element) { instance_double(Nokogiri::XML::Element) }
    let(:elements) { Array.new(3, nokogiri_element) }
    let(:watir_elements) { Array.new(3, watir_element) }
    let(:doc) { instance_double Nokogiri::HTML::Document }

    it 'uses nokogiri with complex regular expressions for attribute' do
      expect(browser).to receive(:html).and_return '<html></html>'

      @xpath = ".//*[local-name()='li']"
      expect(doc).to receive(:xpath).with(@xpath).and_return(elements)

      expect(elements[0]).to receive(:attribute).with('id').and_return('no')
      expect(elements[1]).to receive(:attribute).with('id').and_return('foobar')
      expect(elements[2]).to_not receive(:attribute)

      expect(browser).to receive(:elements).with(xpath: @xpath).and_return(watir_elements)

      built = {xpath: @xpath, id: /(foo|bar)/}
      expect(locator.locate(built)).to eq watir_elements[1].wd
    end

    it 'uses nokogiri with complex regular expressions for text' do
      expect(browser).to receive(:html).and_return '<html></html>'

      @xpath = ".//*[local-name()='li']"
      expect(doc).to receive(:xpath).with(@xpath).and_return(elements)

      expect(elements[0]).to receive(:inner_text).and_return('no')
      expect(elements[1]).to receive(:inner_text).and_return('foobar')
      expect(elements[2]).to_not receive(:inner_text)

      expect(browser).to receive(:elements).with(xpath: @xpath).and_return(watir_elements)

      built = {xpath: @xpath, text: /(foo|bar)/}
      expect(locator.locate(built)).to eq watir_elements[1].wd
    end

    it 'uses nokogiri with complex regular expressions for tag name' do
      expect(browser).to receive(:html).and_return '<html></html>'

      @xpath = './/*'
      expect(doc).to receive(:xpath).with(@xpath).and_return(elements)

      expect(elements[0]).to receive(:name).and_return('div')
      expect(elements[1]).to receive(:name).and_return('li')
      expect(elements[2]).to_not receive(:name)

      expect(browser).to receive(:elements).with(xpath: @xpath).and_return(watir_elements)

      built = {xpath: @xpath, tag_name: /(ol|li)/}

      expect(locator.locate(built)).to eq watir_elements[1].wd
    end
  end
end
