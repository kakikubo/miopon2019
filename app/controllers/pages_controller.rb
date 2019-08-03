# frozen_string_literal: true

require 'pry'
require 'faraday'
class PagesController < ApplicationController
  before_action :authenticate_user!, :social_profile

  def user_info
    # binding.pry
    # raise "error" # 500 error test
  end

  def callback; end

  def register
    access_token = params[:access_token]
    expires_in = Time.now + params[:expires_in].to_i
    @user = User.find_by_email(current_user.email)
    @user.access_token = access_token
    @user.expires_in = expires_in
    @user.save
    redirect_to pages_mio_config_path
  end

  def mio_config
    @user = User.find_by_email(current_user.email)
  end

  def mio_update_user
    return nil unless request.xhr?

    developer_id = params[:developer_id]
    @user = User.find_by_email(current_user.email)
    @user.developer_id = developer_id
    @user.save
    render json: developer_id
  end

  def mio_update
    Iijmio.crawl_rest_log(current_user.email)
    redirect_to pages_mio_data_path
  end

  def mio_data
    @target_date = current_month
    @target_month = @target_date.strftime('%Y%m')
    month_start = @target_month + '01'
    month_end = @target_month + '31'

    @user = User.find_by_email(current_user.email)
    @items = Iijmio.where(email: current_user.email, day: month_start..month_end).order(:day)

    labels = @items.map { |x| x.day[-2..-1] }
    lte_data = @items.map(&:lte_data)
    restricted_data = @items.map(&:restricted_data)
    label_name_lte = @target_month + '(LTE)'
    label_name_restricted = @target_month + '(200k)'
    dataset1 = dataset1(label: label_name_restricted, data: restricted_data)
    dataset2 = dataset2(label: label_name_lte, data: lte_data)
    datasets = [dataset1, dataset2]
    @graph_data = {
      labels: labels,
      datasets: datasets
    }

    respond_to do |format|
      format.html
      file_name = "items-#{Time.zone.now.strftime('%Y%m%d%S')}.csv"
      format.csv { send_data Iijmio.where(email: current_user.email).order(:day).generate_csv, filename: file_name }
    end
  end

  private

  def dataset1(opts = {})
    dataset1 = { label: opts[:label] }
    dataset1.merge!(backgroundColor: 'rgba(220,220,220,0.2)')
    dataset1.merge!(borderColor: 'rgba(220,220,220,1)')
    dataset1.merge!(data: opts[:data])
    dataset1
  end

  def dataset2(opts = {})
    dataset2 = { label: opts[:label] }
    dataset2.merge!(backgroundColor: 'rgba(151,187,205,0.2)')
    dataset2.merge!(borderColor: 'rgba(151,187,205,1)')
    dataset2.merge!(data: opts[:data])
    dataset2
  end

  def current_month
    if params[:date]
      DateTime.new(params['date']['year'].to_i, params['date']['month'].to_i)
    else
      DateTime.current
    end
  end

  def social_profile
    @profile = SocialProfile.find_by_email(current_user.email)
  end
end
