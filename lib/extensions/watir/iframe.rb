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

    alias_method :watir_switch!, :switch!
    def switch!
      @browser.doc = nil
      watir_switch!
    end

  end # FramedDriver

end # Watir
