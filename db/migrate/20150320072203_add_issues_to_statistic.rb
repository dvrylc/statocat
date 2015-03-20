class AddIssuesToStatistic < ActiveRecord::Migration
  def change
    add_column :user_statistics, :total_open_issues, :integer, :default => 0
    add_column :user_statistics, :average_open_issues, :float, :default => 0.00
    add_column :user_statistics, :total_have_issues, :integer, :default => 0
    add_column :user_statistics, :percentage_have_issues, :float, :default => 0.00
  end
end
