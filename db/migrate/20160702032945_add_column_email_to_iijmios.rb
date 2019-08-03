# frozen_string_literal: true

class AddColumnEmailToIijmios < ActiveRecord::Migration[5.2]
  # rails g migration AddColumnEmailToIijmios email:string
  def change
    add_column :iijmios, :email, :string, null: false, default: 'kakikubo@gmail.com'
  end
end
