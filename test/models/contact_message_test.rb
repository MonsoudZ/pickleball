require "test_helper"

class ContactMessageTest < ActiveSupport::TestCase
  test "accepts a complete inquiry" do
    inquiry = ContactMessage.new(
      name: "Taylor Player",
      email: "taylor@example.com",
      age_group: "Adult (18-54)",
      skill_level: "Intermediate",
      message: "I would like to work on my third shot.",
      policy_accepted: true
    )

    assert inquiry.valid?
    assert_equal "new", inquiry.status
  end

  test "rejects an unsupported status" do
    inquiry = ContactMessage.new(status: "spam")

    assert_not inquiry.valid?
    assert_includes inquiry.errors[:status], "is not included in the list"
  end

  test "requires a guardian for youth requests" do
    inquiry = ContactMessage.new(
      name: "Parent Player",
      email: "parent@example.com",
      age_group: "Junior (8-12)",
      skill_level: "Beginner",
      message: "Training request for my child.",
      policy_accepted: true
    )

    assert_not inquiry.valid?
    assert_includes inquiry.errors[:guardian_name], "can't be blank"

    inquiry.guardian_name = "Parent Player"
    assert inquiry.valid?
  end

  test "captures waitlist status from the selected session" do
    coach = Coach.create!(name: "Waitlist Coach", years_experience: 1)
    training_session = TrainingSession.create!(
      title: "Full Clinic",
      starts_at: 1.week.from_now,
      ends_at: 1.week.from_now + 1.hour,
      location: "Private Court",
      skill_level: "Intermediate",
      spots_total: 4,
      spots_booked: 4,
      coach: coach
    )
    inquiry = ContactMessage.new(
      name: "Taylor Player",
      email: "taylor@example.com",
      age_group: "Adult (18-54)",
      skill_level: "Intermediate",
      message: "Please add me to the waitlist.",
      policy_accepted: true,
      training_session: training_session
    )

    assert inquiry.valid?
    assert inquiry.waitlist?
    assert_equal "Waitlist", inquiry.request_type
  end
end
