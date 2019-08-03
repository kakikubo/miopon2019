# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  def self.find_for_google_oauth2(auth)
    user = User.where(email: auth.info.email).first

    user ||= User.create(name: auth.info.name,
                         provider: auth.provider,
                         uid: auth.uid,
                         email: auth.info.email,
                         token: auth.credentials.token,
                         password: Devise.friendly_token[0, 20])
    user
  end
  has_many :social_profiles, dependent: :destroy
  def social_profile(provider)
    social_profiles.select { |sp| sp.provider == provider.to_s }.first
  end
end
