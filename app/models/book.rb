class Book < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  has_attached_file :picture
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/

  validates :title, presence: true
end
