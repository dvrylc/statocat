class AddAverageStarsToUserStatistics < ActiveRecord::Migration
  def change
    add_column :user_statistics, :average_stars, :float
  end
end
