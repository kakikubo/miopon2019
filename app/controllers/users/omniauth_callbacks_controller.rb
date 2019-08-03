# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.find_for_google_oauth2(request.env['omniauth.auth'])

    if @user.persisted?
      success_message = 'devise.omniauth_callbacks.success'
      flash[:notice] = I18n.t success_message, kind: 'Google'
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.google_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end

  def google
    @omniauth = request.env['omniauth.auth']
    @user = User.find_for_google_oauth2(@omniauth)

    if @user.persisted?
      success_message = 'devise.omniauth_callbacks.success'
      flash[:notice] = I18n.t success_message, kind: 'Google'
      profile_opts = { provider: @omniauth['provider'], uid: @omniauth['uid'] }
      @profile = SocialProfile.where(profile_opts).first
      unless @profile
        @profile = SocialProfile.where(profile_opts).new
        @profile.user = current_user || @user
        @profile.values = @omniauth
        @profile.save!
      end
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.google_data'] = @omniauth
      @profile.values = @omniauth
      redirect_to new_user_registration_url
    end
  end
end
