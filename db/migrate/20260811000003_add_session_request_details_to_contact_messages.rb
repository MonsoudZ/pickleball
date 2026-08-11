class AddSessionRequestDetailsToContactMessages < ActiveRecord::Migration[8.1]
  def change
    add_reference :contact_messages, :training_session, foreign_key: { on_delete: :nullify }
    add_column :contact_messages, :waitlist, :boolean, null: false, default: false
  end
end
