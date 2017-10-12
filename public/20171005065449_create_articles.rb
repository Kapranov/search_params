class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.string :name
      t.text :body
      t.string :authors
      t.string :genres

      t.timestamps
    end
  end
end
