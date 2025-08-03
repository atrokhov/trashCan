class Folder < ApplicationRecord
  belongs_to :user
  belongs_to :folder, optional: true

  has_many :user_files
  has_many :folders

  validates :name, presence: true

  def name_with_extention
    name
  end
end
