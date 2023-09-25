class Session < ApplicationRecord

  has_many :track_session_speeches, dependent: :destroy
  has_many :speeches, through: :track_session_speeches
  has_many :tracks, through: :track_session_speeches

end
