# frozen_string_literal: true

class AddExpiresInToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :expires_in, :datetime
  end
end
