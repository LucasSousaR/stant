class AddCheckSessionToSpeech < ActiveRecord::Migration[7.0]
  def change
    add_column :speeches, :check_session, :boolean
  end
end
