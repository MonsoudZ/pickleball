class ContactMessage
  include ActiveModel::Model
  include ActiveModel::Attributes

  AGE_GROUPS = [
    "Junior (8-12)",
    "Teen (13-17)",
    "Adult (18-54)",
    "Senior (55+)"
  ].freeze

  SKILL_LEVELS = [
    "Beginner",
    "Intermediate",
    "Advanced",
    "Competitive Tournament"
  ].freeze

  attribute :name, :string
  attribute :email, :string
  attribute :phone, :string
  attribute :age_group, :string
  attribute :skill_level, :string
  attribute :goals, :string
  attribute :message, :string

  validates :name, :email, :age_group, :skill_level, :message, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :age_group, inclusion: { in: AGE_GROUPS }
  validates :skill_level, inclusion: { in: SKILL_LEVELS }
end
