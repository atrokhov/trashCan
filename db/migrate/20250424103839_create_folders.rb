class CreateFolders < ActiveRecord::Migration[8.0]
  def change
    create_table :folders do |t|
      t.string :name, null: false, default: ''
      t.references :user, null: false, foreign_key: true
      t.boolean :visible, null: false, default: true

      t.timestamps
    end

    add_index :folders, :name
  end
end
