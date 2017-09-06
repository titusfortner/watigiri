module Watir

  class Element

    # TODO - reimplement with Watir Executor when available

    #
    # Uses Nokogiri to return the text of the element.
    #
    # @return [String]
    #

    def text!
      @selector[:nokogiri] = true
      text
    end

    def attribute!(attr)
      @selector[:nokogiri] = true
      attribute(attr).to_s
    end

    def value!
      attribute!('value')
    end

  end # Element
end # Watir
