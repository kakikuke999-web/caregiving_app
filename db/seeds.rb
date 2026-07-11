# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Bootstrap an initial admin so a fresh environment (e.g. Render) isn't
# stuck with no one able to pass authorization checks. Self-registered
# users default to role: nil, which every Pundit policy denies.
# Set ADMIN_EMAIL to promote that user to admin on the next deploy/boot.
if (admin_email = ENV["ADMIN_EMAIL"]).present?
  user = User.find_by("LOWER(email) = ?", admin_email.strip.downcase)
  if user && !user.admin?
    user.update!(role: :admin)
    puts "Promoted #{user.email} to admin"
  elsif user.nil?
    puts "ADMIN_EMAIL set to #{admin_email.inspect} but no matching user was found"
  end
end

VisitType.find_or_create_by!(name: "デイサービス")

# 過去のデイサービス日誌（紙の記録）を登録する際、記入者として名前だけ分かって
# いたスタッフの仮アカウント。パスワードは起動のたびにランダム生成し、初回作成時
# のみログに出力する（ログにしか残らず、リポジトリには一切保存されない）。
# 本人が使う前にオーナーがパスワードを再設定・案内すること。
[
  ["staff_higuchi@example.com", "樋口"],
  ["staff_arisa@example.com", "ありさ"],
  ["staff_honda@example.com", "本田"],
  ["staff_ueno@example.com", "上野"],
  ["staff_ito@example.com", "伊藤"],
  ["staff_yamazawa@example.com", "山澤"]
].each do |email, name|
  next if User.exists?(email: email)

  temp_password = SecureRandom.alphanumeric(20)
  User.create!(
    email: email,
    name: name,
    role: :staff,
    password: temp_password,
    password_confirmation: temp_password
  )
  puts "Created staff account #{email} (#{name}) with temporary password: #{temp_password} (change it before handing off to the real staff member)"
end
