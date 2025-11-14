class CreateVisitTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :visit_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
