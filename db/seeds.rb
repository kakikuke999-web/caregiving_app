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
