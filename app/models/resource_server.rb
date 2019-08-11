class ResourceServer < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :resources, dependent: :destroy
end
