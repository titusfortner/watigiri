module Watigiri
  module Locators
    module SelectorHelpers
      def normalized_selector
        @selector.delete(:nokogiri)
        super
      end
    end

    class Element
      class SelectorBuilder < Watir::Locators::Element::SelectorBuilder
        include SelectorHelpers
      end
    end

    class Button
      class SelectorBuilder < Watir::Locators::Button::SelectorBuilder
        include SelectorHelpers
      end
    end

    class Cell
      class SelectorBuilder < Watir::Locators::Cell::SelectorBuilder
        include SelectorHelpers
      end
    end

    class Row
      class SelectorBuilder < Watir::Locators::Row::SelectorBuilder
        include SelectorHelpers
      end
    end

    class TextArea
      class SelectorBuilder < Watir::Locators::TextArea::SelectorBuilder
        include SelectorHelpers
      end
    end

    class TextField
      class SelectorBuilder < Watir::Locators::TextField::SelectorBuilder
        include SelectorHelpers
      end
    end
  end
end
