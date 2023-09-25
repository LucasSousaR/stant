class CreateTrackSessionSpeech < ActiveRecord::Migration[7.0]
  def change
    create_table :track_session_speeches do |t|
      t.references :track, foreign_key: true
      t.references :session, foreign_key: true
      t.references :speech, foreign_key: true
      t.string :initial_hour
      t.string :finish_hour
      t.timestamps
    end
  end
end
