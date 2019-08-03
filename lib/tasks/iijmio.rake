#! /usr/bin/env ruby
# frozen_string_literal: true

namespace :iijmio do
  desc 'iijmioのデータ使用量を取得する'
  task usage: :environment do
    Iijmio.crawl
  end
end
