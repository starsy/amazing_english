class AddEventIdToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :event_id, :int
    add_index :answers, :event_id
  end
end
