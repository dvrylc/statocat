class AddStarsToUserStatistic < ActiveRecord::Migration
  def change
    add_column :user_statistics, :stars, :integer
  end
end
