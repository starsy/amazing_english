class AddTrainerToEvents < ActiveRecord::Migration
  def change
	add_column :events, :trainer, :string
  end
end
