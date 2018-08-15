require 'watirspec_helper'

describe Watigiri do
  require 'watirspec_helper'

  describe '#text!' do
    before do
      browser.goto(WatirSpec.url_for('non_control_elements.html'))
    end

    it 'locates with page_source driver call' do
      expect(browser.driver).to_not receive(:find_element)
      expect(browser.driver).to_not receive(:find_elements)

      expect(browser.li(id: 'non_link_1').text!).to eq 'Non-link 1'
      expect(browser.li(id: /non_link_1/).text!).to eq 'Non-link 1'
      expect(browser.li(title: 'This is not a link!').text!).to eq 'Non-link 1'
      expect(browser.li(title: /This is not a link!/).text!).to eq 'Non-link 1'
      expect(browser.li(class: 'nonlink').text!).to eq 'Non-link 1'
      expect(browser.li(class: /nonlink/).text!).to eq 'Non-link 1'
      expect(browser.li(id: /non_link/, index: 1).text!).to eq 'Non-link 2'
      expect(browser.li(xpath: "//li[@id='non_link_1']").text!).to eq 'Non-link 1'
      expect(browser.li(css: 'li#non_link_1').text!).to eq 'Non-link 1'
    end

    it 'locates with inner html driver call' do
      div = browser.div(id: 'header').tap(&:exist?)
      expect(browser.driver).to_not receive(:find_element)
      expect(browser.driver).to_not receive(:find_elements)

      expect(div.li(id: 'non_link_1').text!).to eq 'Non-link 1'
      expect(div.li(id: /non_link_1/).text!).to eq 'Non-link 1'
      expect(div.li(title: 'This is not a link!').text!).to eq 'Non-link 1'
      expect(div.li(title: /This is not a link!/).text!).to eq 'Non-link 1'
      expect(div.li(class: 'nonlink').text!).to eq 'Non-link 1'
      expect(div.li(class: /nonlink/).text!).to eq 'Non-link 1'
      expect(div.li(id: /non_link/, index: 1).text!).to eq 'Non-link 2'
      expect(div.li(xpath: "//li[@id='non_link_1']").text!).to eq 'Non-link 1'
      expect(div.li(css: 'li#non_link_1').text!).to eq 'Non-link 1'
    end

    it 'reloads the cached document from after hooks' do
      expect(browser.driver).to receive(:page_source).exactly(3).times.and_return(browser.driver.page_source)

      expect(browser.li(id: 'non_link_1').text!).to eq 'Non-link 1'
      browser.refresh
      expect(browser.li(id: /non_link_1/).text!).to eq 'Non-link 1'
      browser.li.click
      expect(browser.li(title: 'This is not a link!').text!).to eq 'Non-link 1'
      browser.li.click
    end

    it 'locates by sub-element' do
      navbar = browser.ul(id: 'navbar').tap(&:exist?)
      expect(browser.driver).to_not receive(:find_element)
      expect(browser.driver).to_not receive(:find_elements)
      expect(navbar.li(id: 'non_link_1').text!).to eq 'Non-link 1'
    end

    describe '#exists?' do
      it 'finds Watir::Element when selector uses regular expression' do
        expect_any_instance_of(Selenium::WebDriver::Element).to_not receive(:attribute)

        li = browser.li(id: /link/, index: 1)
        expect(li).to exist
        expect(li).to be_a(Watir::Element)
      end
    end
  end
end
