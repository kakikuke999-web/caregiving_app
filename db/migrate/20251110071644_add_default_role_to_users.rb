class AddDefaultRoleToUsers < ActiveRecord::Migration[7.1]
  def change
      def change
    change_column_default :users, :role, from: nil, to: 1  # 1 = :staff
    end

  end
end
