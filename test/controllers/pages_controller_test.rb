require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    Rails.cache.clear

    @coach = Coach.create!(name: "Test Coach", years_experience: 2)
    @program = TrainingProgram.create!(
      title: "Quick Start",
      level: "Beginner",
      duration_weeks: 2,
      price_cents: 12000
    )

    @training_session = TrainingSession.create!(
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
    assert_select "p", /1 hour.*Capacity: 8 players.*\$120 program/
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
    assert_select "input[name='contact_message[website]']", 1
  end

  test "prefills a selected session" do
    get contact_url(session_id: @training_session.id)

    assert_response :success
    assert_select "input[name='contact_message[training_session_id]'][value='#{@training_session.id}']", 1
    assert_select "p", text: @training_session.title
    assert_select "p", /6 spots currently available/
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
          message: "Looking for 2 sessions per week.",
          training_session_id: @training_session.id
        }
      }
    end

    assert_redirected_to contact_url
    follow_redirect!
    assert_select "div", /request was received/
    assert_equal "new", ContactMessage.order(:created_at).last.status
    inquiry = ContactMessage.order(:created_at).last
    assert_predicate inquiry, :policy_accepted?
    assert_equal @training_session, inquiry.training_session
    assert_not inquiry.waitlist?
  end

  test "records a waitlist request for a full session" do
    @training_session.update!(spots_booked: @training_session.spots_total)

    assert_difference("ContactMessage.count", 1) do
      post contact_url, params: {
        contact_message: {
          name: "Taylor Player",
          email: "taylor@example.com",
          age_group: "Adult (18-54)",
          policy_accepted: "1",
          skill_level: "Intermediate",
          message: "Please add me to the waitlist.",
          training_session_id: @training_session.id
        }
      }
    end

    inquiry = ContactMessage.order(:created_at).last
    assert inquiry.waitlist?
    assert_equal @training_session, inquiry.training_session
    assert_redirected_to contact_url
  end

  test "does not associate an unpublished session from submitted parameters" do
    @training_session.update!(published: false)

    post contact_url, params: {
      contact_message: {
        name: "Taylor Player",
        email: "taylor@example.com",
        age_group: "Adult (18-54)",
        policy_accepted: "1",
        skill_level: "Intermediate",
        message: "Training request.",
        training_session_id: @training_session.id
      }
    }

    assert_nil ContactMessage.order(:created_at).last.training_session
  end

  test "silently discards honeypot submissions" do
    assert_no_difference("ContactMessage.count") do
      post contact_url, params: {
        contact_message: {
          name: "Spam Bot",
          website: "https://spam.example"
        }
      }
    end

    assert_redirected_to contact_url
    assert_equal "Thanks, your request was received. I will contact you to confirm availability and details.", flash[:notice]
  end

  test "rate limits repeated submissions from one address" do
    submission = {
      contact_message: {
        name: "Taylor Player",
        email: "taylor@example.com",
        age_group: "Adult (18-54)",
        policy_accepted: "1",
        skill_level: "Intermediate",
        message: "Training request."
      }
    }

    assert_difference("ContactMessage.count", 5) do
      6.times { post contact_url, params: submission }
    end

    assert_redirected_to contact_url
    assert_equal "Too many requests were submitted. Please try again in a few minutes.", flash[:alert]
  end
end
