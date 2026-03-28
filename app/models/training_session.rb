class TrainingSession < ApplicationRecord
  belongs_to :coach
  belongs_to :training_program, optional: true

  scope :upcoming, -> { where("starts_at >= ?", Time.current).order(:starts_at) }

  validates :title, :starts_at, :ends_at, :location, :skill_level, presence: true
  validates :spots_total, numericality: { greater_than: 0 }
  validates :spots_booked, numericality: { greater_than_or_equal_to: 0 }
  validate :ends_after_starts
  validate :spots_booked_within_capacity

  def full?
    spots_booked >= spots_total
  end

  def spots_remaining
    spots_total - spots_booked
  end

  private

  def ends_after_starts
    return if starts_at.blank? || ends_at.blank?
    return if ends_at > starts_at

    errors.add(:ends_at, "must be after the start time")
  end

  def spots_booked_within_capacity
    return if spots_total.blank? || spots_booked.blank?
    return if spots_booked <= spots_total

    errors.add(:spots_booked, "cannot exceed total spots")
  end
end
