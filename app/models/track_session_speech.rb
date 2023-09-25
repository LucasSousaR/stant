class TrackSessionSpeech  < ApplicationRecord

  belongs_to :track
  belongs_to :session
  belongs_to :speech
end
