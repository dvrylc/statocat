class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.string :name
      t.string :username
      t.integer :followers
      t.integer :following
      t.datetime :join_date
      t.integer :public_repos
      t.integer :public_gists

      t.timestamps null: false
    end
  end
end
