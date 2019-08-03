#! /usr/bin/env ruby
# frozen_string_literal: true

namespace :iijmio do
  desc 'iijmioのデータ使用量を取得する'
  task get_usage: :environment do
    $LOAD_PATH.unshift File.dirname(__FILE__)
    require 'iijmio_crawler'
    url = 'http://www.amazon.co.jp/gp/rss/bestsellers/books/ref=zg_bs_books_rsslink'
    xpath = '//rss/channel/item'
    puts Tasks::Rss20.get_rss(url, xpath)
  end
end
