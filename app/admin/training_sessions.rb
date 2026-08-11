ActiveAdmin.register TrainingSession do
  permit_params :title, :starts_at, :ends_at, :location, :skill_level, :spots_total, :spots_booked, :coach_id, :training_program_id, :notes, :published, :status

  includes :coach, :training_program

  scope :all, default: true
  scope("Published") { |sessions| sessions.publicly_visible }
  scope("Drafts") { |sessions| sessions.where(published: false) }
  scope("Canceled") { |sessions| sessions.where(status: "canceled") }

  index do
    selectable_column
    id_column
    column :title
    column("Visibility") { |session| status_tag(session.published? ? "Published" : "Draft") }
    column(:status) { |session| status_tag(session.status) }
    column :starts_at
    column :ends_at
    column :location
    column :skill_level
    column :spots_total
    column :spots_booked
    column :coach
    column :training_program
    actions
  end

  filter :title
  filter :starts_at
  filter :location
  filter :skill_level
  filter :published
  filter :status, as: :select, collection: TrainingSession::STATUSES
  filter :coach
  filter :training_program

  form do |f|
    f.inputs do
      f.input :title
      f.input :published, hint: "Only published, scheduled sessions appear on the public site."
      f.input :status, as: :select, collection: TrainingSession::STATUSES, include_blank: false
      f.input :starts_at
      f.input :ends_at
      f.input :location
      f.input :skill_level
      f.input :spots_total
      f.input :spots_booked
      f.input :coach
      f.input :training_program
      f.input :notes
    end
    f.actions
  end
end
