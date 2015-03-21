class AddPagesToStatistic < ActiveRecord::Migration
  def change
    add_column :user_statistics, :total_pages, :integer, :default => 0
    add_column :user_statistics, :percentage_pages, :float, :default => 0.00
  end
end
