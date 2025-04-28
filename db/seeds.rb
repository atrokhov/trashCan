require 'action_dispatch/http/upload'

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.create(
  email: "admin@mail.com",
  password: "password",
  password_confirmation: "password",
  role: :admin,
  full_name: "Admin Root"
)

folder = Folder.create user: user, name: 'Folder'

file_path = Rails.root.join('public', 'icon.png')

uploaded_file = ActionDispatch::Http::UploadedFile.new(
  tempfile: File.new(file_path),
  filename: File.basename(file_path),
  content_type: 'image/png',
  headers: "Content-Disposition: form-data; name=\"user_file[file]\"; filename=\"#{File.basename(file_path)}\"\r\n"
)

UserFiles::Create.call(
  user: user,
  folder: folder,
  file: uploaded_file,
  read_only: false
)

UserFiles::Create.call(
  user: user,
  folder: folder,
  file: uploaded_file,
  read_only: true
)
