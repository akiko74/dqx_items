class FetchBazaar

  def rlogin
    Headless.ly do
      driver = Selenium::WebDriver.for :firefox
      driver.manage.timeouts.implicit_wait = 10
      driver.navigate.to 'http://hiroba.dqx.jp'
        if driver.find_element(:id, 'btn_login').present?
          driver.find_element(:id, 'btn_login').click
          if driver.find_element(:name, '_pr_confData_sqexid').present?
            driver.find_element(:name, '_pr_confData_sqexid').send_keys('3qr_dqx')
            driver.find_element(:name, '_pr_confData_passwd').send_keys('3qrsquar1103')
            driver.find_element(:name, '_pr_confData_saveId').click()
            driver.find_element(:id, 'btLogin').click
            if driver.current_url == 'http://hiroba.dqx.jp/sc/public/welcome/'
              driver.find_element(:link, "キャラクター選択へ").click
              if driver.current_url == "http://hiroba.dqx.jp/sc/login/characterselect/"
                driver.find_element(:xpath, '/html/body/div[2]/div/div/div/div[2]/form/table/tbody/tr[2]/td[4]/a').click
              end
            end
          end
        end
        items = Item.all.map {|item| item.name }
        doc = Nokogiri::HTML(driver.page_source)
        CSV.open("file.csv", "wb") do |csv|
          items.each do |item|
          driver.navigate.to 'http://hiroba.dqx.jp/sc/home'
            unless doc.css('div#bazaarList a')[0].present? && doc.css('div#bazaarList a')[0].text == item
              driver.find_element(:id, "searchword").send_keys(item)
              driver.find_element(:name, "submit").click
              driver.find_element(:id, "searchTabItem").click
              driver.find_element(:link, item).click
              driver.find_element(:link, "旅人バザーから探す").click
              doc = Nokogiri::HTML(driver.page_source)
            end
          price_ary = []
          amount = 0
          total = 0
          doc.css('div#bazaarList p').each do |content|
            case content.text
              when /^個数/
                content.text=~/[0-9]+/
                amount = $&.to_i
              when /^価格/
                content.text=~/[0-9|,]+/
                total = $&.gsub(",","").to_i
            end
            if amount > 0 && total > 0
              price_ary << total / amount
              total = 0
              amount = 0
            end
          end
          item_price = price_ary.inject(0) {|sum, price| sum + price } / price_ary.count rescue 0
          csv << [item, item_price]
          ary_test << [item, item_price]
        end
      end
    end
  end
end
