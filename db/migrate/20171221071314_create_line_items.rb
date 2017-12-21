class CreateLineItems < ActiveRecord::Migration[5.1]
  def change
    create_table :line_items do |t|
      t.references :book, foreign_key: true
      t.references :cart, foreign_key: true

      t.timestamps
    end
  end
end
