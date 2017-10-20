class AddPictureToBook < ActiveRecord::Migration[5.1]
  def change
    add_attachment :books, :picture
  end
end
