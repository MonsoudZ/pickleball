require "test_helper"

class TrainingSessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    coach = Coach.create!(name: "Coach Casey", years_experience: 4)

    @training_session = TrainingSession.create!(
      title: "Drop Shot Reps",
      starts_at: Time.zone.local(2026, 4, 5, 18, 0),
      ends_at: Time.zone.local(2026, 4, 5, 19, 30),
      location: "Private Court",
      skill_level: "Intermediate",
      spots_total: 10,
      spots_booked: 4,
      coach: coach
    )
  end

  test "renders calendar index" do
    get calendar_url(month: "2026-04")

    assert_response :success
    assert_select "h1", /Training Calendar/
  end

  test "renders session details" do
    get training_session_url(@training_session)

    assert_response :success
    assert_match "Drop Shot Reps", @response.body
  end
end
