class AddWikiToStatistic < ActiveRecord::Migration
  def change
    add_column :user_statistics, :total_wikis, :integer, :default => 0
    add_column :user_statistics, :percentage_wikis, :float, :default => 0.00
  end
end
