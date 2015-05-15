class AddIsTrainerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_trainer, :boolean
  end
end
