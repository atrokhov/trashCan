class AddSettingsToFolder < ActiveRecord::Migration[8.0]
  def change
    add_column :folders, :read_only, :boolean, default: false, null: false
    add_column :folders, :settings, :jsonb, default: {}, null: false
  end
end
