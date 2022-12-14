class Product < ApplicationRecord
  belongs_to :category
  validates :name, 
            presence: true, 
            uniqueness: { scope: :category_id },
            length: { maximum: 100 }
  validates :qty,
            presence: true,
            numericality: { only_integer: true }
end
