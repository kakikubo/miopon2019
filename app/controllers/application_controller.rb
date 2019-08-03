# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # http://qiita.com/dalaito0514/items/fb1ea251197003deec12
  # rescue_from ActiveRecord::RecordNotFound, with: :render_404
  # rescue_from ActionController::RoutingError, with: :render_404
  # rescue_from Exception, with: :render_500

  def render_404
    render template: 'errors/error_404', status: 404, layout: 'errors', content_type: 'text/html'
  end

  def render_500
    render template: 'errors/error_500', status: 500, layout: 'errors', content_type: 'text/html'
  end
end
