class CreateCarePlans < ActiveRecord::Migration[7.1]
  def change
    create_table :care_plans do |t|
      t.references :care_recipient, null: false, foreign_key: true
      t.date :created_on
      t.string :office_name
      t.text :policy_summary
      t.text :family_intention
      t.text :certification_committee_opinion
      t.string :assistance_reason

      t.timestamps
    end
  end
end
