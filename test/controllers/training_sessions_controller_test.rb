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
      published: true,
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
    assert_select "p", /Duration:.*1 hr 30 min/
    assert_select "p", /Capacity:.*10 players/
    assert_select "a", text: "Request this session" do |links|
      assert_equal contact_path(session_id: @training_session.id), links.first["href"]
    end
  end

  test "offers a waitlist when the session is full" do
    @training_session.update!(spots_booked: @training_session.spots_total)

    get training_session_url(@training_session)

    assert_response :success
    assert_select "p", /Full.*waitlist requests are open/
    assert_select "a", text: "Join waitlist" do |links|
      assert_equal contact_path(session_id: @training_session.id), links.first["href"]
    end
  end

  test "does not show unpublished sessions" do
    @training_session.update!(published: false)

    get calendar_url(month: "2026-04")

    assert_response :success
    assert_no_match "Drop Shot Reps", response.body
  end

  test "does not show canceled sessions" do
    @training_session.update!(status: "canceled")

    get training_session_url(@training_session)

    assert_response :not_found
  end
end
