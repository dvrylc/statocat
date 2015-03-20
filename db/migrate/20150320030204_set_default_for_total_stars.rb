class SetDefaultForTotalStars < ActiveRecord::Migration
  def change
    change_column :user_statistics, :total_stars, :integer, :default => 0
  end
end
