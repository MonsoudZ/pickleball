require "test_helper"

class AdminDashboardTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in admin_users(:one)
    coach = Coach.create!(name: "Dashboard Coach", years_experience: 1)
    @training_session = TrainingSession.create!(
      title: "Dashboard Clinic",
      starts_at: 1.week.from_now,
      ends_at: 1.week.from_now + 1.hour,
      location: "Private Court",
      skill_level: "Intermediate",
      spots_total: 6,
      spots_booked: 2,
      published: true,
      coach: coach
    )
    @inquiry = ContactMessage.create!(
      name: "Taylor Player",
      email: "taylor@example.com",
      age_group: "Adult (18-54)",
      skill_level: "Intermediate",
      message: "Interested in the clinic.",
      policy_accepted: true,
      training_session: @training_session
    )
  end

  test "renders operational dashboard metrics" do
    get admin_root_url

    assert_response :success
    assert_match "Coaching Dashboard", response.body
    assert_match "New inquiries", response.body
    assert_match "Upcoming published sessions", response.body
    assert_match "Canceled sessions", response.body
    assert_match @inquiry.name, response.body
    assert_match @training_session.title, response.body
  end

  test "updates inquiry status with one-click actions" do
    put mark_contacted_admin_contact_message_url(@inquiry)
    assert_redirected_to admin_contact_message_url(@inquiry)
    assert_equal "contacted", @inquiry.reload.status

    put mark_closed_admin_contact_message_url(@inquiry)
    assert_equal "closed", @inquiry.reload.status

    put reopen_admin_contact_message_url(@inquiry)
    assert_equal "new", @inquiry.reload.status
  end
end
