# frozen_string_literal: true

class CustomAuthenticationFailure < Devise::FailureApp
  protected

  def redirect_url
    welcome_index_path
    # root_path ## redirect_to 'root' case
    # root_path+"users/auth/facebook" # redirect_to facebook auth case
  end
end
