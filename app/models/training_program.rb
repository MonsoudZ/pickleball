class TrainingProgram < ApplicationRecord
  has_many :training_sessions, dependent: :nullify

  validates :title, :level, :duration_weeks, presence: true
  validates :duration_weeks, numericality: { greater_than: 0 }
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }

  def price_dollars
    price_cents.to_i / 100.0
  end
end
