module Watigiri
  class Element
    attr_reader :element, :selector

    def initialize(element:, selector:)
      @element = element
      @selector = selector
    end
  end

  module Locators
    module LocatorHelpers
      def locate
        @nokogiri = @selector.delete(:nokogiri)
        @regex = regex?

        return super unless @nokogiri || @regex
        @query_scope.browser.doc ||= Nokogiri::HTML(@query_scope.html).tap { |d| d.css('script').remove }

        element = find_first_by_multiple
        return if element.nil?
        @nokogiri ? element.element : nokogiri_to_selenium(element)
      end

      def locate_all
        @nokogiri = @selector.delete(:nokogiri)
        @regex = regex?

        return super unless @nokogiri || @regex
        @query_scope.browser.doc ||= Nokogiri::HTML(@query_scope.html).tap { |d| d.css('script').remove }

        elements = find_all_by_multiple#.map(&:element)
        @nokogiri ? elements : elements.map { |element| nokogiri_to_watir element }
      end

      # Is only used when there is no regex, index or visibility locators
      def locate_element(how, what)
        return super unless @nokogiri

        el = @query_scope.browser.doc.send("at_#{how}", what)
        Watigiri::Element.new element: el, selector: {how => what}
      end

      # "how" can only be :css or :xpath
      def locate_elements(how, what, _scope = @query_scope.wd)
        return super unless (@nokogiri || @regex) && @query_scope.is_a?(Watir::Browser)

        @query_scope.browser.doc.send(how, what).map do |el|
          Watigiri::Element.new element: el, selector: {how => what}
        end
      end

      def filter_elements noko_elements, visible, idx, number
        return super unless @nokogiri || @regex
        return super if noko_elements.first.is_a?(Selenium::WebDriver::Element)

        unless visible.nil?
          noko_elements.select! { |el| visible == nokogiri_to_watir(el.element).visible? }
        end
        number == :single ? noko_elements[idx || 0] : noko_elements
      end

      def filter_elements_by_regex(noko_elements, rx_selector, method)
        return if noko_elements.empty?
        return super if noko_elements.first.is_a?(Selenium::WebDriver::Element)

        if @nokogiri || !@regex
          return noko_elements.__send__(method) { |el| matches_selector?(el.element, rx_selector) }
        end

        selenium_elements = ensure_scope_context.find_elements(noko_elements.first.selector)

        if method == :select
          selenium_elements.zip(noko_elements).each_with_object([]) do |els, array|
            array << els.first if matches_selector?(els.last.element, rx_selector)
          end
        else
          index = noko_elements.find_index { |el| matches_selector?(el.element, rx_selector) }
          index.nil? ? nil : selenium_elements[index]
        end
      end

      def fetch_value(element, how)
        return super unless @nokogiri || @regex
        return super if element.is_a?(Selenium::WebDriver::Element)
        case how
        when :text
          element.inner_text
        when :tag_name
          element.name.to_s.downcase
        when :href
          (href = element.attribute('href')) && href.to_s.strip
        else
          element.attribute(how.to_s.tr("_", "-")).to_s
        end
      end

      def nokogiri_to_watir(element)
        return element if element.is_a?(Selenium::WebDriver::Element)
        se_element = nokogiri_to_selenium(element)
        tag = element.name
        Watir.element_class_for(tag).new(@query_scope, element: se_element)
      end

      def nokogiri_to_selenium(element)
        return element if element.is_a?(Selenium::WebDriver::Element)
        tag = element.name
        index = @query_scope.browser.doc.xpath("//#{tag}").find_index { |el| el == element }
        Watir::Element.new(@query_scope, index: index, tag_name: tag).wd
      end

      def label_from_text(label_exp)
        # TODO: this won't work correctly if @wd is a sub-element
        elements = locate_elements(:xpath, '//label')
        return super if elements.any? { |el| el.is_a? Selenium::WebDriver::Element }
        element = elements.find do |el|
          matches_selector?(el.element, text: label_exp)
        end
        element.nil? ? nil : element.element
      end

      def regex?
        @selector.values.any? { |v| v.is_a?(Regexp) }
      end
    end


    class Element
      class Locator < Watir::Locators::Element::Locator
        include LocatorHelpers
      end
    end

    class Button
      class Locator < Watir::Locators::Button::Locator
        include LocatorHelpers
      end
    end

    class Cell
      class Locator < Watir::Locators::Cell::Locator
        include LocatorHelpers
      end
    end

    class Row
      class Locator < Watir::Locators::Row::Locator
        include LocatorHelpers
      end
    end

    class TextArea
      class Locator < Watir::Locators::TextArea::Locator
        include LocatorHelpers

        def regex?
          @selector.any? { |k, v| v.is_a?(Regexp) && k != :value }
        end
      end
    end

    class TextField
      class Locator < Watir::Locators::TextField::Locator
        include LocatorHelpers

        def matches_selector?(element, rx_selector)
          return super if element.is_a? Selenium::WebDriver::Element
          rx_selector = rx_selector.dup

          tag_name = element.name.downcase

          [:text, :value, :label].each do |key|
            if rx_selector.key?(key)
              correct_key = tag_name == 'input' ? :value : :text
              rx_selector[correct_key] = rx_selector.delete(key)
            end
          end

          rx_selector.all? do |how, what|
            what === fetch_value(element, how)
          end
        end

        def regex?
          @selector.any? { |k, v| v.is_a?(Regexp) && k != :value }
        end
      end
    end
  end
end
