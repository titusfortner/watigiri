module Watigiri
  module Locators
    class Element
      class Locator < Watir::Locators::Element::Locator
        private

        def matching_elements
          return super unless use_nokogiri?

          # Element should be using `#fragment` instead of `#inner_html`, but can't because of
          # https://github.com/sparklemotion/nokogiri/issues/572
          command = locator_scope.is_a?(Watir::Browser) ? :html : :inner_html

          args = wd_locator.to_a.flatten
          args[0] = "at_#{args[0]}" unless match_regexp?

          result = populate_doc command, *args
          match_regexp? ? filter_elements(result) : result
        end

        def filter_elements(elements)
          element_matcher.nokogiri = true
          found = [element_matcher.match(elements, match_values, @filter)].flatten.compact

          se_elements = nokogiri_to_selenium(elements, found)
          @filter == :first ? se_elements.first : se_elements
        end

        def use_nokogiri?
          @nokogiri = @built.delete(:nokogiri)

          # Neither CSS nor XPath locator found
          return false if wd_locator.empty? || @selector.key?(:adjacent)

          @nokogiri && match_values.empty? || match_regexp?
        end

        def populate_doc(command, key, value)
          @query_scope.doc ||= Nokogiri::HTML(locator_scope.send(command)).tap { |d| d.css('script').remove }
          @query_scope.doc.send(key, value)
        end

        def wd_locator
          @wd_locator ||= @built.select { |k, _v| %i[css xpath].include?(k) }
        end

        def match_regexp?
          @match_regexp ||= Watigiri.match_regexp? && match_values.all? do |k, v|
            v.is_a?(Regexp) && !k.to_s.include?('visible') && !k.to_s.include?('label')
          end &&
                            !match_values.empty?
        end

        def nokogiri_to_selenium(elements, found)
          locator_scope.elements(wd_locator).map.each_with_index do |el, idx|
            el.wd if found&.include? elements[idx]
          end.compact
        end
      end
    end

    class TextField
      class Locator < Element::Locator
        def use_nokogiri?
          return false if @built.key?(:text)

          super
        end
      end
    end

    class TextArea
      class Locator < Element::Locator
        def use_nokogiri?
          return false if @built.key?(:value)

          super
        end
      end
    end

    class Cell
      class Locator < Element::Locator
        def use_nokogiri?
          false
        end
      end
    end

    class Row
      class Locator < Element::Locator
        def use_nokogiri?
          false
        end
      end
    end
  end
end
