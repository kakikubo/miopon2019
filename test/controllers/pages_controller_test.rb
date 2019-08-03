# frozen_string_literal: true

require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test 'should get user_info' do
    get :user_info
    assert_response :success
  end
end
