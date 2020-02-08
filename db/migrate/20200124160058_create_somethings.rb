# frozen_string_literal: true

class CreateSomethings < ActiveRecord::Migration[6.0]
  def change
    create_table :somethings do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :int
      t.string :str
      t.date :date
      t.integer :nest

      t.timestamps
    end
  end
end
