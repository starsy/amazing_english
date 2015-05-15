class AddIsSolutionPublishedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :is_solution_published, :boolean
  end
end
