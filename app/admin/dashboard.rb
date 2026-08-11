# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: "Coaching Dashboard" do
    columns do
      column do
        panel "New inquiries" do
          h2 link_to(ContactMessage.where(status: "new").count, admin_contact_messages_path(scope: "new"))
          para "Requests waiting for a response"
        end
      end

      column do
        panel "Upcoming published sessions" do
          h2 link_to(TrainingSession.publicly_visible.upcoming.count, admin_training_sessions_path(scope: "published"))
          para "Visible sessions still ahead"
        end
      end

      column do
        panel "Canceled sessions" do
          h2 link_to(TrainingSession.where(status: "canceled").count, admin_training_sessions_path(scope: "canceled"))
          para "Sessions removed from the public calendar"
        end
      end
    end

    panel "Newest inquiries" do
      table_for ContactMessage.includes(:training_session).where(status: "new").order(created_at: :desc).limit(8) do
        column :created_at
        column :name
        column("Request") { |message| status_tag(message.request_type) }
        column :training_session
        column :goals
        column do |message|
          span do
            text_node link_to("View", admin_contact_message_path(message))
            text_node " "
            text_node link_to("Mark contacted", mark_contacted_admin_contact_message_path(message), method: :put)
          end
        end
      end
    end

    columns do
      column do
        panel "Next published sessions" do
          table_for TrainingSession.publicly_visible.upcoming.limit(8) do
            column :starts_at
            column(:title) { |session| link_to session.title, admin_training_session_path(session) }
            column("Availability") do |session|
              session.full? ? status_tag("Full") : "#{session.spots_remaining} open"
            end
          end
        end
      end

      column do
        panel "Recently canceled" do
          table_for TrainingSession.where(status: "canceled").order(updated_at: :desc).limit(8) do
            column :starts_at
            column(:title) { |session| link_to session.title, admin_training_session_path(session) }
            column :updated_at
          end
        end
      end
    end
  end
end
