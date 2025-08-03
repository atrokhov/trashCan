class UserFile < ApplicationRecord
  belongs_to :folder
  belongs_to :user

  has_one_attached :file

  enum :file_type, {
    image: 0,
    video: 1,
    audio: 2,
    application: 3,
    text: 4,
    font: 5,
    another: 6
  }

  def name_with_extention
    "#{file_name}.#{file_extension}"
  end
end
