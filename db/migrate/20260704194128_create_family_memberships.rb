class CreateFamilyMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :family_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :care_recipient, null: false, foreign_key: true

      t.timestamps
    end

    add_index :family_memberships, [:user_id, :care_recipient_id], unique: true
  end
end
