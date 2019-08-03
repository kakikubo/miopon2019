# frozen_string_literal: true

module ApplicationHelper
  def active_page?(path)
    path == request.path
  end
end
