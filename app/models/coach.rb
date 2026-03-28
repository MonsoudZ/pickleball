class Coach < ApplicationRecord
  has_many :training_sessions, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :years_experience, numericality: { greater_than_or_equal_to: 0 }

  def specialties_list
    specialties.to_s.split(",").map(&:strip).reject(&:blank?)
  end
end
