class SitemapController < ApplicationController
  layout false

  def show
    @base_url = ENV.fetch("SITE_URL", request.base_url).delete_suffix("/")
    @static_paths = [ root_path, about_path, calendar_path, pricing_path, faq_path, contact_path, policies_path ]
    @sessions = TrainingSession.publicly_visible.where("ends_at >= ?", Time.current).order(:starts_at)

    expires_in 12.hours, public: true
  end

  def robots
    base_url = ENV.fetch("SITE_URL", request.base_url).delete_suffix("/")
    render plain: "User-agent: *\nAllow: /\nDisallow: /admin\nSitemap: #{base_url}/sitemap.xml\n"
  end
end
