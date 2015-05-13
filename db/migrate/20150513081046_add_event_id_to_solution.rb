class AddEventIdToSolution < ActiveRecord::Migration
  def change
    add_column :solutions, :event_id, :int
    add_index :solutions, :event_id
  end
end
