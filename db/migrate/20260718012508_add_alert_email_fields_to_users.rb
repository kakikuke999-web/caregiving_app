class AddAlertEmailFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :alert_emails_enabled, :boolean, default: true, null: false
    add_column :users, :last_alert_email_sent_on, :date
  end
end
