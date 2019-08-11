class Resource < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :resource_server
end
