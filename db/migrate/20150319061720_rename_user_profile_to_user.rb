class RenameUserProfileToUser < ActiveRecord::Migration
  def change
    rename_table :user_profiles, :users
  end
end
