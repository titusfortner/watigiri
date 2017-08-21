module Watigiri
  module Locators
    class Element
      class Locator < Watir::Locators::Element::Locator

        def locate
          @nokogiri = @selector.delete(:nokogiri)

          return super unless @nokogiri
          @query_scope.browser.doc ||= Nokogiri::HTML(@query_scope.html).tap {|d| d.css('script').remove }

          reset_doc = ->(browser) { browser.doc = nil }
          @query_scope.browser.after_hooks.add(reset_doc)

          find_first_by_multiple
        end

        def locate_element(how, what)
          unless @nokogiri
            return ensure_scope_context.find_element(how, what)
          end
          case how
          when :css
            @query_scope.browser.doc.at_css(what)
          when :xpath
            @query_scope.browser.doc.at_xpath(what)
          end
        end

        def locate_elements(how, what, _scope = nil)
          unless @nokogiri
            return ensure_scope_context.find_elements(how, what)
          end
          case how
          when :css
            @query_scope.browser.doc.css(what).to_a
          when :xpath
            @query_scope.browser.doc.xpath(what).to_a
          end
        end

        def fetch_value(element, how)
          return super unless @nokogiri
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

        # TODO remove after https://github.com/watir/watir/pull/630
        def find_first_by_multiple
          selector = selector_builder.normalized_selector

          idx = selector.delete(:index) unless selector[:adjacent]
          visible = selector.delete(:visible)

          how, what = selector_builder.build(selector)

          if how
            # could build xpath/css for selector
            if idx || !visible.nil?
              idx ||= 0
              elements = locate_elements(how, what)
              elements = elements.select { |el| visible == el.displayed? } unless visible.nil?
              elements[idx] unless elements.nil?
            else
              locate_element(how, what)
            end
          else
            # can't use xpath, probably a regexp in there
            if idx || !visible.nil?
              idx ||= 0
              elements = wd_find_by_regexp_selector(selector, :select)
              elements = elements.select { |el| visible == el.displayed? } unless visible.nil?
              elements[idx] unless elements.nil?
            else
              wd_find_by_regexp_selector(selector, :find)
            end
          end
        end

        # TODO Remove after https://github.com/watir/watir/pull/630
        def wd_find_by_regexp_selector(selector, method = :find)
          query_scope = ensure_scope_context
          rx_selector = delete_regexps_from(selector)

          if rx_selector.key?(:label) && selector_builder.should_use_label_element?
            label = label_from_text(rx_selector.delete(:label)) || return
            if (id = label.attribute(:for))
              selector[:id] = id
            else
              query_scope = label
            end
          end

          how, what = selector_builder.build(selector)

          unless how
            raise Error, "internal error: unable to build Selenium selector from #{selector.inspect}"
          end

          if how == :xpath && can_convert_regexp_to_contains?
            rx_selector.each do |key, value|
              next if key == :tag_name || key == :text

              predicates = regexp_selector_to_predicates(key, value)
              what = "(#{what})[#{predicates.join(' and ')}]" unless predicates.empty?
            end
          end

          elements = locate_elements(how, what, query_scope)
          elements.__send__(method) { |el| matches_selector?(el, rx_selector) }
        end

        # TODO Remove after https://github.com/watir/watir/pull/630
        def ensure_scope_context
          @query_scope.wd
        end

      end
    end
  end
end
