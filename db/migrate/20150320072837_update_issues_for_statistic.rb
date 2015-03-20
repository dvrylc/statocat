class UpdateIssuesForStatistic < ActiveRecord::Migration
  def change
    rename_column :user_statistics, :total_open_issues, :total_issues
    rename_column :user_statistics, :average_open_issues, :average_issues
    remove_column :user_statistics, :total_have_issues
    remove_column :user_statistics, :percentage_have_issues
  end
end
