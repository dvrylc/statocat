class AddWatchersToStatistic < ActiveRecord::Migration
  def change
    add_column :user_statistics, :total_watchers, :integer, :default => 0
    add_column :user_statistics, :average_watchers, :float, :default => 0.00
  end
end
