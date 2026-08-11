class PagesController < ApplicationController
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
    @contact_message = ContactMessage.new
    set_contact_options
  end

  def create_contact
    @contact_message = ContactMessage.new(contact_message_params)
    set_contact_options

    if @contact_message.save
      flash[:notice] = "Thanks #{@contact_message.name}, your request was received. I will contact you to confirm availability and details."
      redirect_to contact_path
    else
      render :contact, status: :unprocessable_entity
    end
  end

  private

  def contact_message_params
    params.expect(contact_message: [ :name, :email, :phone, :age_group, :guardian_name, :skill_level, :goals, :message, :policy_accepted ])
  end

  def set_contact_options
    @age_group_options = ContactMessage::AGE_GROUPS
    @skill_level_options = ContactMessage::SKILL_LEVELS
  end
end
