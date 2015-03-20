class AddForksToStatistic < ActiveRecord::Migration
  def change
    change_column :user_statistics, :average_stars, :float, :default => 0.00
    add_column :user_statistics, :total_forks, :integer, :default => 0
    add_column :user_statistics, :average_forks, :float, :default => 0.00
  end
end
