module ApplicationHelper
  BUSINESS_NAME = "Pickleball Performance Lab".freeze
  DEFAULT_DESCRIPTION = "Private pickleball coaching, clinics, and player development in Evergreen, Colorado for beginner through competitive players.".freeze

  def seo_title
    title = content_for(:title).presence || "Pickleball Coaching in Evergreen, Colorado"
    "#{title} | #{BUSINESS_NAME}"
  end

  def seo_description
    content_for(:description).presence || DEFAULT_DESCRIPTION
  end

  def site_base_url
    ENV.fetch("SITE_URL", request.base_url).delete_suffix("/")
  end

  def canonical_url
    "#{site_base_url}#{request.path == '/' ? '/' : request.path}"
  end

  def open_graph_image_url
    "#{site_base_url}/og-evergreen-pickleball.png"
  end

  def business_email
    ENV["BUSINESS_EMAIL"].presence
  end

  def business_phone
    ENV["BUSINESS_PHONE"].presence
  end

  def session_duration_label(training_session)
    minutes = ((training_session.ends_at - training_session.starts_at) / 1.minute).round
    hours, remaining_minutes = minutes.divmod(60)

    return "#{minutes} min" if hours.zero?
    return pluralize(hours, "hour") if remaining_minutes.zero?

    "#{hours} hr #{remaining_minutes} min"
  end

  def session_price_label(training_session)
    return unless training_session.training_program

    "#{number_to_currency(training_session.training_program.price_dollars, precision: 0)} program"
  end

  def local_business_schema
    {
      "@context": "https://schema.org",
      "@type": "LocalBusiness",
      name: BUSINESS_NAME,
      description: DEFAULT_DESCRIPTION,
      url: site_base_url,
      image: open_graph_image_url,
      priceRange: "$$",
      address: {
        "@type": "PostalAddress",
        addressLocality: "Evergreen",
        addressRegion: "CO",
        addressCountry: "US"
      },
      areaServed: {
        "@type": "City",
        name: "Evergreen, Colorado"
      },
      email: business_email,
      telephone: business_phone
    }.compact
  end
end
