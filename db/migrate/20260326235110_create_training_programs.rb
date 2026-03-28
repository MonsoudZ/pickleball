class CreateTrainingPrograms < ActiveRecord::Migration[8.1]
  def change
    create_table :training_programs do |t|
      t.string :title, null: false
      t.string :level, null: false
      t.integer :duration_weeks, null: false
      t.string :focus_area
      t.text :description
      t.integer :price_cents, null: false, default: 0

      t.timestamps
    end
  end
end
