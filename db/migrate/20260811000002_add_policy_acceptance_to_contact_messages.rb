class AddPolicyAcceptanceToContactMessages < ActiveRecord::Migration[8.1]
  def change
    add_column :contact_messages, :guardian_name, :string
    add_column :contact_messages, :policy_accepted, :boolean, null: false, default: false
  end
end
