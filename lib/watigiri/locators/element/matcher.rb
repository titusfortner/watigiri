module Watigiri
  module Locators
    module MatcherHelpers
      attr_accessor :nokogiri

      def matching_labels(elements, *)
        nokogiri ? elements : super
      end

      def fetch_value(element, how)
        return super unless nokogiri

        case how
        when :text
          element.inner_text
        when :href
          element.attribute('href')&.to_s&.strip
        when :tag_name
          element.name.downcase
        else
          super.to_s
        end
      end

      def deprecate_text_regexp(*)
        # not applicable to Watigiri
      end
    end

    class Button
      class Matcher < Watir::Locators::Button::Matcher
        include MatcherHelpers
      end
    end

    class Element
      class Matcher < Watir::Locators::Element::Matcher
        include MatcherHelpers
      end
    end

    class TextField
      class Matcher < Watir::Locators::TextField::Matcher
        include MatcherHelpers
      end
    end
  end
end
