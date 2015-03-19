class AddAvatarUrlToUserProfile < ActiveRecord::Migration
  def change
    add_column :user_profiles, :avatar, :string
  end
end
