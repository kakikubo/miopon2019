#! /usr/bin/env ruby
# frozen_string_literal: true

# IIJmio Crawler for packet usage report

require 'kconv'
require 'open-uri'
require 'uri'
require 'logger'

# require 'rubygems'
require 'nokogiri'
require 'mechanize'

class MioParser
  LOGIN_URL = 'https://www.iijmio.jp/auth/login.jsp'
  LOGIN_FORM_ACTION = '/j_security_check'
  LOGIN_FORM_ID = 'j_username'
  LOGIN_FORM_PASS = 'j_password'
  LOGOUT_URL = 'https://www.iijmio.jp/auth/logout.jsp'
  VIEWDATA_URI = 'https://www.iijmio.jp/service/setup/hdd/viewdata/'
  COUPON_URI = 'https://www.iijmio.jp/service/setup/hdd/couponstatus/'
  attr_reader :user_data
  def initialize(user_id, pass, logger = nil)
    @user_id = user_id
    @pass    = pass
    @packet_usage = []
    @agent = Mechanize.new
    if logger.is_a?(Logger)
      @agent.log = logger
    else
      @agent.log = Logger.new(STDOUT)
      @agent.log.level = Logger::INFO
    end
    @logged_in = false
    @user_data = {}
  end

  def login
    begin
      @agent.get(LOGIN_URL)
      @agent.log.info 'Logged in : ' + @agent.page.title
      @agent.page.form_with(action: LOGIN_FORM_ACTION) do |form|
        form.field_with(name: LOGIN_FORM_ID).value = @user_id
        form.field_with(name: LOGIN_FORM_PASS).value = @pass
        form.click_button
      end
    rescue StandardError
      # FIXME: login error could not rescue ..
      @agent.log.error $ERROR_INFO
      return false
    end
    true
  end

  def logout
    @agent.get(LOGOUT_URL)
    @agent.log.info 'Logged out url : ' + @agent.page.title
  end

  def logged_in?
    @logged_in
  end

  def scan_data
    @logged_in = login
    @user_data = scan_user_info
    logout
  end

  private

  # user all data
  def scan_user_info
    @agent.get(VIEWDATA_URI)
    # @agent.log.info 'Usage page title: ' + @agent.page.title

    # past 30 days data
    @agent.page.form.click_button

    user_data = {}
    user_data = scan_contract(user_data)
    user_data = scan_packet_usage(user_data)
    user_data = scan_coupon_rest(user_data)
    user_data
  end

  def scan_contract(user_data)
    contents_number = @agent.page.search('//table[@class="base2"]/tr[2]')

    return user_data unless contents_number

    user_data['number'] = /([\d\-]+)/.match(contents_number[0].inner_text)[1]
    user_data
  end

  def scan_packet_usage(user_data)
    usage_xpath = '//table[@class="base2"]/tr'
    contents = @agent.page.search(usage_xpath)

    return user_data unless contents

    user_data['usage'] = []
    contents.drop(3).each_with_index do |node, _idx|
      contents_data = node.xpath('./td')
      break unless contents_data

      # @agent.log.debug "Usage: #{contents_data}"
      usage_data = {}
      usage_data['date'] = parse_date(contents_data[0].inner_text)
      usage_data['lte_data'] = contents_data[1].inner_text.to_i
      usage_data['restricted_data'] = contents_data[2].inner_text.to_i
      user_data['usage'].push usage_data
    end
    user_data
  end

  def scan_coupon_rest(user_data)
    @agent.get(COUPON_URI)
    # @agent.log.info 'Coupon page title: ' + @agent.page.title

    total = numeric_path(@agent.page, '//table[@class="base2"]/tr[2]/td[2]')
    this_month = numeric_path(@agent.page, '//table[@class="base2"]/tr[3]/td[2]')
    prev_month = numeric_path(@agent.page, '//table[@class="base2"]/tr[4]/td[2]')

    # @agent.log.debug "Coupon data: total=#{total},
    # this_month=#{this_month}, prev_month=#{prev_month}"

    user_data['coupon'] = [total, this_month, prev_month]
    user_data
  end

  def numeric_path(page, xpath)
    contents = page.at(xpath)
    contents ? contents.inner_text.to_i : 0
  end

  def parse_date(str)
    return unless /[\s　]*(\d+)年[\s　]*(\d+)月[\s　]*(\d+)日/ =~ str

    Time.local(Regexp.last_match(1), Regexp.last_match(2), Regexp.last_match(3))
  end
end
