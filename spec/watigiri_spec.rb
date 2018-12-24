require 'watirspec_helper'

describe Watigiri::Locators do
  require 'watirspec_helper'

  describe '#text!' do
    context 'Element' do
      before do
        browser.goto(WatirSpec.url_for('non_control_elements.html'))
      end

      it 'caches html for locating by attribute' do
        expect(browser.driver).to_not receive(:find_element)
        expect(browser.driver).to_not receive(:find_elements)

        expect(browser.li(id: 'non_link_1').text!).to eq 'Non-link 1'
        expect(browser.li(id: /non_link_1/).text!).to eq 'Non-link 1'
      end

      it 'does not cache html for xpath or css' do
        expect(browser).not_to receive(:doc)

        expect(browser.li(xpath: "//li[@id='non_link_1']").text!).to eq 'Non-link 1'
        expect(browser.li(css: 'li#non_link_1').text!).to eq 'Non-link 1'
      end

      it 'caches html for locating nested elements' do
        div = browser.div(id: 'header').locate
        expect(browser.wd).to_not receive(:find_element)
        expect(browser.wd).to_not receive(:find_elements)
        expect(div.wd).to_not receive(:find_element)
        expect(div.wd).to_not receive(:find_elements)

        expect(div.li(id: 'non_link_1').text!).to eq 'Non-link 1'
        expect(div.li(id: /non_link_1/).text!).to eq 'Non-link 1'
      end

      it 'tests scoped elements' do
        div = browser.div(id: 'header').locate
        expect(div.wd).to_not receive(:find_element)
        expect(div.wd).to_not receive(:find_elements)

        expect(div.li(id: 'non_link_1').text!).to eq 'Non-link 1'
      end

      it 'caches inner html for locating nested elements by attribute' do
        div = browser.div(id: 'header').locate
        expect(browser.wd).to_not receive(:find_element)
        expect(browser.wd).to_not receive(:find_elements)
        expect(div.wd).to_not receive(:find_element)
        expect(div.wd).to_not receive(:find_elements)

        expect(div.li(id: 'non_link_1').text!).to eq 'Non-link 1'
        expect(div.li(id: /non_link_1/).text!).to eq 'Non-link 1'
      end

      it 'does not cache inner html locating nested elements by xpath or css' do
        div = browser.div(id: 'header')
        expect(div).not_to receive(:doc)

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
    end
  end
end
