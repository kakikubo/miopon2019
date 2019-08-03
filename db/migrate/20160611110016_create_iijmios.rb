# frozen_string_literal: true

class CreateIijmios < ActiveRecord::Migration[5.2]
  def change
    create_table :iijmios, id: false do |t|
      t.string :day
      t.integer :lte_data
      t.integer :restricted_data

      t.timestamps null: false
    end
    add_index :iijmios, :day, unique: true
  end
end
