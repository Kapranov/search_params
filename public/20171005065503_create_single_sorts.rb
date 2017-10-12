class CreateSingleSorts < ActiveRecord::Migration[5.1]
  def change
    create_table :single_sorts do |t|
      t.belongs_to :list, foreign_key: true
      t.belongs_to :book, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
