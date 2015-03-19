class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.references :user, index: true
      t.json :repo
      t.json :code

      t.timestamps null: false
    end
    add_foreign_key :languages, :users
  end
end
