class SetDefaultForTotalRepos < ActiveRecord::Migration
  def change
    change_column :user_statistics, :total_repos, :integer, :default => 0
  end
end
