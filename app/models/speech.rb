class Speech < ApplicationRecord



  has_many :track_session_speeches, dependent: :destroy
  has_many :sessions, through: :track_session_speeches
  has_many :tracks, through: :track_session_speeches
  # has_paper_trail versions: {
  # scope: -> { order("created_at desc") }
  #}



  scope :date_select_order_init, -> (enum = '') {
    order("#{enum}": :asc)
  }
  def self.ransackable_scopes(auth_object = nil)
    %i(borrower_type_current_eq date_select_order date_select_order_init)
  end
end
