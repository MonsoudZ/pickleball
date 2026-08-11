require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @coach = Coach.create!(name: "Test Coach", years_experience: 2)
    @program = TrainingProgram.create!(
      title: "Quick Start",
      level: "Beginner",
      duration_weeks: 2,
      price_cents: 12000
    )

    TrainingSession.create!(
      title: "Intro Session",
      starts_at: 1.day.from_now.change(hour: 17),
      ends_at: 1.day.from_now.change(hour: 18),
      location: "Private Court",
      skill_level: "Beginner",
      spots_total: 8,
      spots_booked: 2,
      published: true,
      coach: @coach,
      training_program: @program
    )
  end

  test "renders home page" do
    get root_url

    assert_response :success
    assert_select "h1", /Train Smarter/
    assert_select "a", /Browse Calendar/
    assert_select "title", /Pickleball Coaching in Evergreen, Colorado/
    assert_select "meta[name='description'][content*='Evergreen, Colorado']", 1
    assert_select "link[rel='canonical'][href='#{root_url}']", 1
    assert_select "meta[property='og:image'][content$='og-evergreen-pickleball.png']", 1
    assert_select "script[type='application/ld+json']", /LocalBusiness/
  end

  test "renders about page" do
    get about_url

    assert_response :success
    assert_select "h1", /Monsoud Zanaty/
  end

  test "renders faq page" do
    get faq_url

    assert_response :success
    assert_select "h1", /Frequently Asked Questions/
    assert_select "summary", /Is pickleball right for me\?/
  end

  test "renders pricing page" do
    get pricing_url

    assert_response :success
    assert_select "h1", /Choose Your Training Menu/
  end

  test "renders contact page" do
    get contact_url

    assert_response :success
    assert_select "h1", /Request a Training Session/
  end

  test "renders policies page" do
    get policies_url

    assert_response :success
    assert_select "h1", /Clear Expectations for Training/
    assert_select "h2", /Privacy/
    assert_select "h2", /Youth Training/
  end

  test "renders sitemap with canonical public pages" do
    get sitemap_url(format: :xml)

    assert_response :success
    assert_equal "application/xml", response.media_type
    assert_match policies_url, response.body
    assert_match training_session_url(TrainingSession.last), response.body
  end

  test "submits contact form" do
    assert_difference("ContactMessage.count", 1) do
      post contact_url, params: {
        contact_message: {
          name: "Taylor Player",
          email: "taylor@example.com",
          phone: "202-555-0100",
          age_group: "Adult (18-54)",
          policy_accepted: "1",
          skill_level: "Intermediate",
          goals: "Better third-shot consistency",
          message: "Looking for 2 sessions per week."
        }
      }
    end

    assert_redirected_to contact_url
    follow_redirect!
    assert_select "div", /request was received/
    assert_equal "new", ContactMessage.order(:created_at).last.status
    assert_predicate ContactMessage.order(:created_at).last, :policy_accepted?
  end
end
