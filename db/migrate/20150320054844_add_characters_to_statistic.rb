class AddCharactersToStatistic < ActiveRecord::Migration
  def change
    add_column :user_statistics, :total_characters, :integer, :default => 0
    add_column :user_statistics, :average_characters, :float, :default => 0.00
  end
end
