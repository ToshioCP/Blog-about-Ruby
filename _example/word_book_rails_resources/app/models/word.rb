class Word < ApplicationRecord
  validates :en, presence: true, format: {with: /[a-zA-Z]+/}, uniqueness: true
  validates :jp, presence: true
end
