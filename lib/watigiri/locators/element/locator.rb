module Watigiri
  class Element
    attr_reader :element, :selector

    def initialize(element:, selector:)
      @element = element
      @selector = selector
    end

    def tag_name
      element.name.downcase
    end
  end

  module Locators
    module LocatorHelpers
      def locate
        @nokogiri = @selector.delete(:nokogiri)
        return super unless @nokogiri || regex?

        # :inner_html should be using `#fragment`, but can't because of
        # https://github.com/sparklemotion/nokogiri/issues/572
        method = @query_scope.is_a?(Watir::Browser) ? :html : :inner_html

        @query_scope.doc ||= Nokogiri::HTML(@query_scope.send(method)).tap { |d| d.css('script').remove }

        element = using_watir(:first)
        return if element.nil?
        @nokogiri ? element.element : nokogiri_to_selenium(element)
      end

      # Is only used when there is no regex, index or visibility locators
      def locate_element(how, what, _driver_scope = @query_scope.wd)
        return super unless @nokogiri

        el = @query_scope.doc.send("at_#{how}", what)
        Watigiri::Element.new element: el, selector: {how => what}
      end

      # "how" can only be :css or :xpath
      def locate_elements(how, what, _scope = @query_scope.wd)
        return super unless @nokogiri || regex?

        @query_scope.doc.send(how, what).map do |el|
          Watigiri::Element.new element: el, selector: {how => what}
        end
      end

      def fetch_value(element, how)
        element = update_element(element)
        return if element.nil?

        case how
        when :text
          element.inner_text
        when :tag_name
          element.name.to_s.downcase
        when :href
          element.attribute('href')&.to_s
        else
          element.attribute(how.to_s.tr('_', '-')).to_s
        end
      end

      def nokogiri_to_selenium(element)
        return element if element.is_a?(Selenium::WebDriver::Element)
        tag = element.tag_name
        index = @query_scope.doc.xpath(".//#{tag}").find_index { |el| el == element.element }
        Watir::Element.new(@query_scope, index: index, tag_name: tag).wd
      end

      def regex?
        return @regex unless @regex.nil?
        return false unless (@selector.keys & %i[adjacent visible label text visible_text]).empty?
        @regex = @selector.values.any? { |v| v.is_a?(Regexp) }
      end

      def update_element(element)
        if !(@nokogiri || regex?) || element.is_a?(Selenium::WebDriver::Element)
          nil
        elsif element.is_a?(Watigiri::Element)
          element.element
        else
          element
        end
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

        # Don't use for rows
        def regex?
          false
        end
      end
    end

    class Row
      class Locator < Watir::Locators::Row::Locator
        include LocatorHelpers

        # Don't use for rows
        def regex?
          false
        end
      end
    end

    class TextArea
      class Locator < Watir::Locators::TextArea::Locator
        include LocatorHelpers

        def regex?
          return false unless (@selector.keys & %i[adjacent visible label text visible_text]).empty?
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

          tag_name = element.tag_name

          %i[text value label].each do |key|
            next unless rx_selector.key?(key)
            correct_key = tag_name == 'input' ? :value : :text
            rx_selector[correct_key] = rx_selector.delete(key)
          end

          rx_selector.all? do |how, what|
            val = fetch_value(element, how)
            what == val || val =~ /#{what}/
          end
        end

        def regex?
          return false unless (@selector.keys & %i[adjacent visible label text visible_text]).empty?
          @selector.any? { |k, v| v.is_a?(Regexp) && k != :value }
        end
      end
    end
  end
end
