class PagesController < ApplicationController
  rate_limit to: 5, within: 10.minutes, only: :create_contact,
    with: -> { redirect_to contact_path, alert: "Too many requests were submitted. Please try again in a few minutes." }

  def home
    @next_sessions = TrainingSession.includes(:coach).publicly_visible.upcoming.limit(6)
    @programs = TrainingProgram.order(:level, :title)
    @coaches = Coach.order(:name)
  end

  def about
    @coach = Coach.first
  end

  def faq; end

  def pricing
    @programs = TrainingProgram.order(:level, :title)
  end

  def policies; end

  def contact
    @selected_session = selected_training_session
    @contact_message = ContactMessage.new(training_session: @selected_session)
    set_contact_options
  end

  def create_contact
    attributes = contact_message_params
    @selected_session = selected_training_session(attributes.delete(:training_session_id))
    @contact_message = ContactMessage.new(attributes.merge(training_session: @selected_session))
    set_contact_options

    if @contact_message.website.present?
      redirect_to contact_path, notice: generic_contact_notice
      return
    end

    if @contact_message.save
      flash[:notice] = contact_notice
      redirect_to contact_path
    else
      render :contact, status: :unprocessable_entity
    end
  end

  private

  def contact_message_params
    params.expect(contact_message: [ :name, :email, :phone, :age_group, :guardian_name, :skill_level, :goals, :message, :policy_accepted, :training_session_id, :website ])
  end

  def set_contact_options
    @age_group_options = ContactMessage::AGE_GROUPS
    @skill_level_options = ContactMessage::SKILL_LEVELS
  end

  def selected_training_session(id = params[:session_id])
    TrainingSession.publicly_visible.find_by(id: id) if id.present?
  end

  def contact_notice
    if @contact_message.waitlist?
      "Thanks #{@contact_message.name}, your waitlist request was received. I will contact you if a spot becomes available."
    else
      "Thanks #{@contact_message.name}, your request was received. I will contact you to confirm availability and details."
    end
  end

  def generic_contact_notice
    "Thanks, your request was received. I will contact you to confirm availability and details."
  end
end
