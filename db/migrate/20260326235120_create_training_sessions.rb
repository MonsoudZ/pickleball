class CreateTrainingSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :training_sessions do |t|
      t.string :title, null: false
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.string :location, null: false
      t.string :skill_level, null: false
      t.integer :spots_total, null: false, default: 8
      t.integer :spots_booked, null: false, default: 0
      t.references :coach, null: false, foreign_key: true
      t.references :training_program, foreign_key: true
      t.text :notes

      t.timestamps
    end

    add_index :training_sessions, :starts_at
  end
end
