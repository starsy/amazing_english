class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.text :text
      t.string :provider

      t.timestamps null: false
    end
  end
end
