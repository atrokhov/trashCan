FactoryBot.define do
  factory :user_file do
    user { create(:user) }
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'test.txt'), 'text/plain') }
    folder { create(:folder) }
    visible { true }
    read_only { false }
    file_type { 0 }
  end
end
