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

    #
    # Uses Nokogiri to return the attribute of the element.
    #
    # @return [String]
    #

    def attribute!
      @selector[:nokogiri] = true
      text
    end

    #
    # Uses Nokogiri to return the value of the element.
    #
    # @return [String]
    #

    def value!
      @selector[:nokogiri] = true
      text
    end

  end # Element
end # Watir
