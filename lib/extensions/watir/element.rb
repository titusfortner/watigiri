module Watir
  class Element
    attr_reader :doc

    #
    # Store instance of Nokogiri
    #

    def doc=(html)
      @doc = html
      return if html.nil?

      @reset_doc_hook = ->(*) { reset_doc }
      browser.after_hooks.add(@reset_doc_hook)
    end

    def reset_doc
      @doc = nil
      browser.after_hooks.delete(@reset_doc_hook)
    end

    #
    # Uses Nokogiri to return the text of the element.
    #
    # @return [String]
    #

    def text!
      selector_builder.built[:nokogiri] = true
      text.strip
    end

    alias el_stale? stale?
    def stale?
      @doc.nil? && el_stale?
    end
  end # Element
end # Watir
