class AddFolderIdToFolder < ActiveRecord::Migration[8.0]
  def change
    add_reference :folders, :folder, null: true, foreign_key: true
  end
end
