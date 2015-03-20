class RenameStarsToTotalStars < ActiveRecord::Migration
  def change
    rename_column :user_statistics, :stars, :total_stars
  end
end
