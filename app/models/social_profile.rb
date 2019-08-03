# frozen_string_literal: true

# == Schema Information
#
# Table name: social_profiles
#
#  id            :integer          not null, primary key
#  user_id       :integer          not null, indexed
#  provider      :string(255)      not null, indexed => [uid]
#  uid           :string(255)      not null, indexed => [provider]
#  access_token  :string(255)
#  access_secret :string(255)
#  name          :string(255)
#  nickname      :string(255)
#  email         :string(255)
#  url           :string(255)
#  image_url     :string(255)
#  description   :string(255)
#  other         :text
#  credentials   :text
#  raw_info      :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null

class SocialProfile < ActiveRecord::Base
  belongs_to :user
  store :other
  validates_uniqueness_of :uid, scope: :provider

  def values=(omniauth)
    return if provider.to_s != omniauth['provider'].to_s

    return if uid != omniauth['uid']

    credentials = omniauth['credentials']
    info = omniauth['info']
    # self.access_token = credentials['token']
    # self.access_secret = credentials['secret']
    self.credentials = credentials.to_json
    self.email = info['email']
    self.name = info['name']
    self.nickname = info['nickname']
    self.description = info['description'].try(:truncate, 255)
    self.image_url = info['image']
    self.values_by_raw_info = omniauth['extra']['raw_info']
    url_social(provider)
  end

  def self.url_social(provider)
    case provider.to_s
    when 'github'
      self.url = info['urls']['GitHub']
      other[:blog] = info['urls']['Blog']
    when 'google'
      self.nickname ||= info['email'].sub(/(.+)@gmail.com/, '\1')
    when 'twitter'
      self.url = info['urls']['Twitter']
      other[:location] = info['location']
      other[:website] = info['urls']['Website']
    end
  end

  def self.values_by_raw_info=(raw_info)
    case provider.to_s
    when 'google'
      self.url = raw_info['link']
    when 'twitter'
      other[:followers_count] = raw_info['followers_count']
      other[:friends_count] = raw_info['friends_count']
      other[:statuses_count] = raw_info['statuses_count']
    end

    self.raw_info = raw_info.to_json
    save!
  end
end
