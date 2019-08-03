#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pry'
require_relative './miocrawler.rb'

class Tasks::Iijmio
  def self.crawl
    mio = MioParser.new(ENV['EMAIL'], ENV['PASSWORD'], Logger.new('/tmp/log'))
    mio.scan_data
    mio.user_data
  end

  #   @function
  #   @private
  #   @static
  def self.get_rest_api(url, email)
    user = User.find_by_email(email)
    http_client = ::Faraday.new(url: %(https://api.iijmio.jp/mobile/d/))
    # binding.pry
    # http_client.headers[ :user_agent ] = ::Iijmio::CLI.user_agent
    response =
      http_client.get do |request|
        request.url(url)
        request.headers[%(X-IIJmio-Developer)] = user.developer_id
        request.headers[%(X-IIJmio-Authorization)] = user.access_token
        request.headers[%(Content-Type)] = %(application/json)
      end
    if response.status != 200
      warn %{Could NOT get correct response (HTTP STATUS: #{response.status}).}
      exit 1
    end
    ::JSON.parse(response.body)
  end
end
