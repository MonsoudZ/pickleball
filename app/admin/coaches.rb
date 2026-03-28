ActiveAdmin.register Coach do
  permit_params :name, :certification, :years_experience, :specialties, :bio

  index do
    selectable_column
    id_column
    column :name
    column :certification
    column :years_experience
    column :specialties
    column :created_at
    actions
  end

  filter :name
  filter :certification
  filter :years_experience
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :certification
      f.input :years_experience
      f.input :specialties
      f.input :bio
    end
    f.actions
  end
end
