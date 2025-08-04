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

admin = User.create(
  email: "admin@mail.com",
  password: "password",
  password_confirmation: "password",
  role: :admin,
  full_name: "Admin Root"
)

user = User.create(
  email: "user1@mail.com",
  password: "password",
  password_confirmation: "password",
  role: :default_user,
  full_name: "Default User"
)

admin_desktop = Folder.create user: admin, name: 'Desktop', settings: { sort_field: 'created_at', sort_direction: 'DESC' }
Folder.create user: admin, name: 'Empty Folder', folder: admin_desktop, settings: { sort_field: 'created_at', sort_direction: 'DESC' }
admin_folder = Folder.create user: admin, name: 'Folder', folder: admin_desktop, settings: { sort_field: 'created_at', sort_direction: 'DESC' }

user_desktop = Folder.create user: user, name: 'Desktop', settings: { sort_field: 'created_at', sort_direction: 'DESC' }

file_path = Rails.root.join('public', 'icon.png')

uploaded_file = Rack::Test::UploadedFile.new(file_path)

blob = ActiveStorage::Blob.create_and_upload!(
  io: uploaded_file.tempfile,
  filename: uploaded_file.original_filename,
  content_type: 'image/png'
)

UserFiles::Create.call(
  params: {
    user_id: admin.id,
    folder_id: admin_desktop.id,
    file: ActiveStorage::Blob.find_signed(blob.signed_id)
  }
)

UserFiles::Create.call(
  params: {
    user_id: admin.id,
    folder_id: admin_folder.id,
    file: ActiveStorage::Blob.find_signed(blob.signed_id)
  }
)

test_files_path = Rails.root.join('spec', 'fixtures', 'files')
test_file_paths = Dir.children(test_files_path)

100.times do
  test_file_paths.each do |test_file_path|
    mime_type = Rack::Mime.mime_type(File.extname(test_file_path), fallback = 'model/gltf-binary')

    uploaded_test_file = Rack::Test::UploadedFile.new(file_path)

    blob = ActiveStorage::Blob.create_and_upload!(
      io: uploaded_test_file.tempfile,
      filename: uploaded_test_file.original_filename,
      content_type: mime_type
    )

    UserFiles::Create.call(
      params: {
        user_id: user.id,
        folder_id: user_desktop.id,
        file: ActiveStorage::Blob.find_signed(blob.signed_id)
      }
    )
  end
end
