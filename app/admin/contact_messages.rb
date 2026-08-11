ActiveAdmin.register ContactMessage do
  menu priority: 2, label: "Inquiries"

  permit_params :status

  actions :index, :show, :edit, :update, :destroy

  scope :all
  scope("New") { |messages| messages.where(status: "new") }
  scope("Contacted") { |messages| messages.where(status: "contacted") }
  scope("Closed") { |messages| messages.where(status: "closed") }

  index do
    selectable_column
    id_column
    status_tag :status
    column :name
    column :email
    column :phone
    column :guardian_name
    column :skill_level
    column :goals
    column :created_at
    actions
  end

  filter :status, as: :select, collection: ContactMessage::STATUSES
  filter :name
  filter :email
  filter :skill_level, as: :select, collection: ContactMessage::SKILL_LEVELS
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
