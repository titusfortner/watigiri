module Watigiri
  module Locators
    class Element
      class SelectorBuilder < Watir::Locators::Element::SelectorBuilder

        def initialize(query_scope, selector, attribute_list)
          attribute_list << :nokogiri
          super
          @selector.delete :nokogiri
        end

      end
    end
  end
end
