class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :text
      t.string :trainee
      t.float :score

      t.timestamps null: false
    end
  end
end
