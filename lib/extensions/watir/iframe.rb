module Watir
  class IFrame < HTMLElement
    #
    # Uses Nokogiri to return the text of iframe body.
    #
    # @return [String]
    #

    def text!
      body.text!
    end
  end

  class FramedDriver

    private

    def switch!
      @browser.doc = nil
      super
    end

  end # FramedDriver

end # Watir
