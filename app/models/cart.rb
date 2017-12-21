class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy
  has_many :books, through: :line_items

  def add_book(book_id)
    line_items.find_or_initialize_by(book_id: book_id)
  end
end
