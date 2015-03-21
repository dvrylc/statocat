class RemoveWatchersAndWikisFromStatistic < ActiveRecord::Migration
  def change
    remove_column :user_statistics, :total_wikis
    remove_column :user_statistics, :percentage_wikis
    remove_column :user_statistics, :total_watchers
    remove_column :user_statistics, :average_watchers
  end
end
