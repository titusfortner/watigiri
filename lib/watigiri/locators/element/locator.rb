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

          populate_doc command
        end

        def use_nokogiri?
          @built.delete(:nokogiri) && @built.size == 1
        end

        def populate_doc(command)
          @query_scope.doc ||= Nokogiri::HTML(locator_scope.send(command)).tap { |d| d.css('script').remove }
          @query_scope.doc.send("at_#{@built.keys.first}", @built.values.first)
        end
      end
    end
  end
end
