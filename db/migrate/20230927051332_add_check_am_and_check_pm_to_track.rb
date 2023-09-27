class AddCheckAmAndCheckPmToTrack < ActiveRecord::Migration[7.0]
  def change
    add_column :tracks, :check_am, :boolean
    add_column :tracks, :check_pm, :boolean
  end
end
