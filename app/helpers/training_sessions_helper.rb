module TrainingSessionsHelper
  def calendar_days_for(month)
    first_day = month.beginning_of_month.beginning_of_week(:sunday)
    last_day = month.end_of_month.end_of_week(:sunday)

    (first_day..last_day).to_a
  end

  def session_time_range(training_session)
    "#{training_session.starts_at.strftime("%l:%M %p").strip} - #{training_session.ends_at.strftime("%l:%M %p").strip}"
  end
end
