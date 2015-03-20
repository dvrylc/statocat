class RenameLanguageToStatistic < ActiveRecord::Migration
  def change
    rename_table :languages, :user_statistics
    rename_column :user_statistics, :repo, :repo_lang
    rename_column :user_statistics, :code, :code_lang
  end
end
