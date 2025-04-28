class CreateUserFiles < ActiveRecord::Migration[8.0]
  def change
    create_table :user_files do |t|
      t.references :folder, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :read_only, null: false, default: false
      t.boolean :visible, null: true, default: false
      t.integer :file_type, null: false, default: 0
      t.string :file
      t.string :file_name, null: false, default: ''
      t.bigint :file_size, null: false, default: 0
      t.string :file_extension, null: false, default: ''
      t.string :file_mime_type, null: false, default: ''

      t.timestamps
    end

    add_index :user_files, :file_name
  end
end
