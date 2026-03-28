class CreateCoaches < ActiveRecord::Migration[8.1]
  def change
    create_table :coaches do |t|
      t.string :name, null: false
      t.string :certification
      t.integer :years_experience, null: false, default: 0
      t.text :specialties
      t.text :bio

      t.timestamps
    end
  end
end
