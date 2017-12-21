class AddQuantiyToLineitem < ActiveRecord::Migration[5.1]
  def change
    add_column :line_items, :quantity, :integer, default: 0, null: false
  end
end
