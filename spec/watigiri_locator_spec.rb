require 'watirspec_helper'
require 'locator_spec_helper'

module Watigiri
  describe Locators::Element::Locator do
    include LocatorSpecHelper

    let(:matcher) { Watir::Locators::Element::Matcher.new(@query_scope || browser) }
    let(:locator) { described_class.new(matcher) }
    let(:element) { instance_double Nokogiri::XML::Element }

    context 'For Default Elements' do
      it 'uses nokogiri when in built' do
        @xpath = ".//*[local-name()='li'][contains(@class, 'nonlink')]"
        expect(browser).to receive(:html).and_return '<html></html>'

        built = {xpath: @xpath, nokogiri: true}

        expect(locator.locate(built)).to eq element
      end

      it 'does not use nokogiri with extra locators' do
        expect(driver).to receive(:find_elements).and_return([se_element])

        @xpath = ".//*[local-name()='li'][contains(@class, 'nonlink')]"
        built = {xpath: @xpath, nokogiri: true, visible: true}

        expect(locator.locate(built)).to eq se_element
      end

      it 'does not use nokogiri when nokogiri key is not set' do
        expect(driver).to receive(:find_element).and_return(se_element)

        @xpath = ".//*[local-name()='li'][contains(@class, 'nonlink')]"
        built = {xpath: @xpath}

        expect(locator.locate(built)).to eq se_element
      end

      it 'removes scripts' do
        html = '<html><script>Remove</script></html>'
        document = instance_double(Nokogiri::HTML::Document)
        expect(Nokogiri).to receive(:HTML).with(html).and_return(document)

        doc_returned = doc
        expect(document).to receive(:css).with('script').and_return(doc_returned)
        expect(doc_returned).to receive(:remove)

        expect(browser).to receive(:doc=).with(document)

        @xpath = ".//*[local-name()='li'][contains(@class, 'nonlink')]"

        expect(browser).to receive(:html).and_return html

        built = {xpath: @xpath, nokogiri: true}

        expect(locator.locate(built)).to eq element
      end

      context 'with nested elements' do
        it 'uses Element#inner_html if scope argument is present' do
          @xpath = ".//*[local-name()='li'][contains(@class, 'nonlink')]"

          @query_scope = watir_element
          expect(@query_scope).to receive(:inner_html).and_return '<div></div>'
          expect(@query_scope).to receive(:wd).and_return se_element

          built = {xpath: @xpath, nokogiri: true, scope: @query_scope}
          expect(locator.locate(built)).to eq element
        end

        it 'uses Browser#html if query scope is an element but no scope is present' do
          @xpath = ".//*[local-name()='li'][contains(@class, 'nonlink')]"

          @query_scope = watir_element
          expect(@query_scope).to receive(:browser).and_return(browser)
          expect(browser).to receive(:html).and_return('<html></html>')

          built = {xpath: @xpath, nokogiri: true}

          expect(locator.locate(built)).to eq element
        end
      end
    end
  end
end
