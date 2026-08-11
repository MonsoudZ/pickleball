ActiveAdmin.register ContactMessage do
  menu priority: 2, label: "Inquiries"

  permit_params :status

  actions :index, :show, :edit, :update, :destroy

  scope :all
  scope("New") { |messages| messages.where(status: "new") }
  scope("Contacted") { |messages| messages.where(status: "contacted") }
  scope("Closed") { |messages| messages.where(status: "closed") }

  member_action :mark_contacted, method: :put do
    resource.update!(status: "contacted")
    redirect_back fallback_location: admin_contact_message_path(resource), notice: "Inquiry marked as contacted."
  end

  member_action :mark_closed, method: :put do
    resource.update!(status: "closed")
    redirect_back fallback_location: admin_contact_message_path(resource), notice: "Inquiry closed."
  end

  member_action :reopen, method: :put do
    resource.update!(status: "new")
    redirect_back fallback_location: admin_contact_message_path(resource), notice: "Inquiry reopened."
  end

  action_item :mark_contacted, only: :show, if: proc { resource.status == "new" } do
    link_to "Mark contacted", mark_contacted_admin_contact_message_path(resource), method: :put
  end

  action_item :mark_closed, only: :show, if: proc { resource.status != "closed" } do
    link_to "Close inquiry", mark_closed_admin_contact_message_path(resource), method: :put
  end

  action_item :reopen, only: :show, if: proc { resource.status == "closed" } do
    link_to "Reopen inquiry", reopen_admin_contact_message_path(resource), method: :put
  end

  index do
    selectable_column
    id_column
    status_tag :status
    column :name
    column :email
    column :phone
    column :guardian_name
    column("Request") { |message| status_tag(message.request_type) }
    column :training_session
    column :skill_level
    column :goals
    column :created_at
    actions defaults: true do |message|
      if message.status == "new"
        item "Mark contacted", mark_contacted_admin_contact_message_path(message), method: :put
      end
      if message.status != "closed"
        item "Close", mark_closed_admin_contact_message_path(message), method: :put
      else
        item "Reopen", reopen_admin_contact_message_path(message), method: :put
      end
    end
  end

  filter :status, as: :select, collection: ContactMessage::STATUSES
  filter :name
  filter :email
  filter :skill_level, as: :select, collection: ContactMessage::SKILL_LEVELS
  filter :waitlist
  filter :training_session
  filter :created_at

  show do
    attributes_table do
      row :status
      row :name
      row :email
      row :phone
      row :age_group
      row :guardian_name
      row :skill_level
      row("Request type") { |message| status_tag(message.request_type) }
      row :training_session
      row :goals
      row :message
      row :policy_accepted
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "Inquiry status" do
      f.input :status, as: :select, collection: ContactMessage::STATUSES, include_blank: false
    end
    f.actions
  end
end
