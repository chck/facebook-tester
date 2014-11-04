require "json"
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "Test" do

  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "https://m.facebook.com/home.php"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end
  
  it "test_" do
    @driver.get(@base_url + "/login.php?next=https%3A%2F%2Fm.facebook.com%2Fhome.php&refsrc=https%3A%2F%2Fm.facebook.com%2Fhome.php&_rdr")
    @driver.find_element(:name, "email").clear
    @driver.find_element(:name, "email").send_keys ""
    @driver.find_element(:name, "pass").clear
    @driver.find_element(:name, "pass").send_keys ""
    @driver.find_element(:name, "login").click
  end
  
  def element_present?(how, what)
    ${receiver}.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    ${receiver}.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue ExpectationNotMetError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = ${receiver}.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
