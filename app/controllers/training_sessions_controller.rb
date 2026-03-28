class TrainingSessionsController < ApplicationController
  before_action :set_training_session, only: :show

  def index
    @month = parsed_month
    visible_range = @month.beginning_of_month.beginning_of_week(:sunday).beginning_of_day..@month.end_of_month.end_of_week(:sunday).end_of_day

    @sessions = TrainingSession.includes(:coach, :training_program)
                               .where(starts_at: visible_range)
                               .order(:starts_at)
    @sessions_by_day = @sessions.group_by { |session| session.starts_at.to_date }
  end

  def show; end

  private

  def set_training_session
    @training_session = TrainingSession.includes(:coach, :training_program).find(params[:id])
  end

  def parsed_month
    return Date.current.beginning_of_month if params[:month].blank?

    Date.strptime(params[:month], "%Y-%m").beginning_of_month
  rescue ArgumentError
    Date.current.beginning_of_month
  end
end
