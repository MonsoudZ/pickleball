xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  @static_paths.each do |path|
    xml.url do
      xml.loc "#{@base_url}#{path}"
    end
  end

  @sessions.each do |training_session|
    xml.url do
      xml.loc "#{@base_url}#{training_session_path(training_session)}"
      xml.lastmod training_session.updated_at.iso8601
    end
  end
end
