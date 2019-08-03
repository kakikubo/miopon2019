# frozen_string_literal: true

class AddColumnDeveloperIdAndAccessTokenAndTelNumberToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :developer_id, :string
    add_column :users, :access_token, :string
    add_column :users, :tel_number, :string
  end
end
