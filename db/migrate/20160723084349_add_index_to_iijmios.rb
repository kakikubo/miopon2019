# frozen_string_literal: true

class AddIndexToIijmios < ActiveRecord::Migration[5.2]
  def change
    add_index :iijmios, %i[day email], unique: true
    remove_index :iijmios, :day
  end
end
