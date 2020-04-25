require 'selenium-webdriver'
require 'uri'

class InstagramBot
    attr_accessor :driver
    def initialize(username,password)
        Selenium::WebDriver::Chrome.driver_path = "../chromedriver.exe"
        li = 'chrome/81.0.4044.122 Mozilla/75.0'
        caps = Selenium::WebDriver::Remote::Capabilities.chrome('chromeOptions' => { args: ["--user-agent=#{li}", 'window-size=1280x800', '--incognito'] })
        client = Selenium::WebDriver::Remote::Http::Default.new
        client.read_timeout = 360
        @driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps, http_client: client
        @driver.manage.timeouts.implicit_wait = 30
        @driver.navigate.to'https://www.instagram.com/accounts/login/?source=auth_switcher'
        @driver.find_element(:name, 'username').send_keys(username)
        @driver.find_element(:name, 'password').send_keys(password)
        sleep(1)
        @driver.find_element(:name, 'password').send_keys(:return)
    end

    #自動いいね
    def good_hashtag(key_word,number)
        encode_word = URI.encode(key_word)
        sleep 3
        @driver.navigate.to"https://www.instagram.com/explore/tags/#{encode_word}/"
        sleep 2
        @driver.execute_script("document.querySelectorAll('article img')[9].click()")
        sleep 2
        number.times{
          begin
            @driver.execute_script("document.querySelectorAll('span.glyphsSpriteHeart__outline__24__grey_9')[1].click()")
          rescue
            puts "already good this post"
          end
          sleep 2
          @driver.execute_script("document.querySelector('a.coreSpriteRightPaginationArrow').click()")
          sleep 2
        }
      end
    
    #特定のアカウントをいいね
    def good_user_post(username,number)
        sleep 3
        @driver.navigate.to"https://www.instagram.com/#{username}/"
        sleep 2
        @driver.execute_script("document.querySelectorAll('article img')[0].click()")
        sleep 2
        number.times{
          begin
            @driver.execute_script("document.querySelectorAll('span.glyphsSpriteHeart__outline__24__grey_9')[1].click()")
          rescue
            puts "already good this post"
          end
          sleep 2
          @driver.execute_script("document.querySelector('a.coreSpriteRightPaginationArrow').click()")
          sleep 2
        }
      end

      #自動フォロー
      def hashtag_follow(follow_word, number)
        encode_word = URI.encode(follow_word)
        sleep(3)
        @driver.navigate.to"https://www.instagram.com/explore/tags/#{follow_word}/"
        sleep(2)
        @driver.execute_script("document.querySelectorAll('article img')[9].click()")
        sleep(2)
        number.times{
          begin
            @driver.execute_script("document.querySelector('body article .y3zKF').click()")
          rescue
            puts "already followed"
          end
          sleep(2)
          @driver.execute_script("document.querySelector('a.coreSpriteRightPaginationArrow').click()")
          sleep(2)
        }
      end
end

username = "******" #ユーザーネーム
password = "******" #パスワード
bot = InstagramBot.new(username,password)
key_word = "ハッシュタグの指定"
bot.good_hashtag(key_word,1)
follow_word = "ハッシュタグの指定"
bot.hashtag_follow(follow_word, 2)
