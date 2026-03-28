ActiveAdmin.register TrainingProgram do
  permit_params :title, :level, :duration_weeks, :focus_area, :description, :price_cents

  index do
    selectable_column
    id_column
    column :title
    column :level
    column :duration_weeks
    column :focus_area
    column(:price) { |program| number_to_currency(program.price_dollars) }
    column :created_at
    actions
  end

  filter :title
  filter :level
  filter :duration_weeks
  filter :focus_area
  filter :price_cents

  form do |f|
    f.inputs do
      f.input :title
      f.input :level
      f.input :duration_weeks
      f.input :focus_area
      f.input :description
      f.input :price_cents
    end
    f.actions
  end
end
