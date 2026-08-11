class ContactMessage < ApplicationRecord
  attr_accessor :website

  AGE_GROUPS = [
    "Junior (8-12)",
    "Teen (13-17)",
    "Adult (18-54)",
    "Senior (55+)"
  ].freeze
  YOUTH_AGE_GROUPS = AGE_GROUPS.first(2).freeze

  SKILL_LEVELS = [
    "Beginner",
    "Intermediate",
    "Advanced",
    "Competitive Tournament"
  ].freeze

  STATUSES = %w[new contacted closed].freeze

  belongs_to :training_session, optional: true

  before_validation :capture_waitlist_status, on: :create

  validates :name, :email, :age_group, :skill_level, :message, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :age_group, inclusion: { in: AGE_GROUPS }
  validates :skill_level, inclusion: { in: SKILL_LEVELS }
  validates :status, inclusion: { in: STATUSES }
  validates :policy_accepted, inclusion: { in: [ true ], message: "must be accepted" }
  validates :guardian_name, presence: true, if: :youth_request?

  def youth_request?
    age_group.in?(YOUTH_AGE_GROUPS)
  end

  def request_type
    waitlist? ? "Waitlist" : "Session request"
  end

  private

  def capture_waitlist_status
    self.waitlist = training_session&.full? || false
  end
end
