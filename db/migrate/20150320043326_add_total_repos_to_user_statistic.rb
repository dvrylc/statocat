class AddTotalReposToUserStatistic < ActiveRecord::Migration
  def change
    add_column :user_statistics, :total_repos, :integer
  end
end
