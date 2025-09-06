class Category < ApplicationRecord
  has_many :transactions, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :color, presence: true, format: { with: /\A#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})\z/, message: 'must be a valid hex color' }

  scope :income_categories, -> { where(name: %w[Salary Freelance Investment Interest Bonus Other_Income]) }
  scope :expense_categories, -> { where.not(name: %w[Salary Freelance Investment Interest Bonus Other_Income]) }
end
