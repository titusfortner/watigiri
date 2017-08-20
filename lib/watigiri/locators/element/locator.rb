module Watigiri
  module Locators
    class Element
      class Locator < Watir::Locators::Element::Locator

        def locate
          @nokogiri = @selector.delete(:nokogiri)
          @nokogiri = true if @nokogiri.nil? && @selectors.values.any? { |e| e.is_a? Regexp }

          return super unless @nokogiri
          @query_scope.browser.doc ||= Nokogiri::HTML(@query_scope.html).tap {|d| d.css('script').remove }

          reset_doc = ->(browser) { browser.doc = nil }
          @query_scope.browser.after_hooks.add(reset_doc)

          find_first_by_multiple
        end

        def locate_element(how, what)
          return super if @nokogiri.nil?
          case how
          when :css
            @query_scope.browser.doc.at_css(what)
          when :xpath
            @query_scope.browser.doc.at_xpath(what)
          end
        end

        def locate_elements(how, what, _scope = nil)
          return super if @nokogiri.nil?
          case how
          when :css
            @query_scope.browser.doc.css(what).to_a
          when :xpath
            @query_scope.browser.doc.xpath(what).to_a
          end
        end

        def fetch_value(element, how)
          return super if @nokogiri.nil?
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

      end
    end
  end
end
