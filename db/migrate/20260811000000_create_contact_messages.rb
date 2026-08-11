class CreateContactMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :contact_messages do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone
      t.string :age_group, null: false
      t.string :skill_level, null: false
      t.string :goals
      t.text :message, null: false
      t.string :status, null: false, default: "new"

      t.timestamps
    end

    add_index :contact_messages, :status
    add_index :contact_messages, :created_at
  end
end
