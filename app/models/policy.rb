class Policy < ApplicationRecord
  belongs_to :user
  belongs_to :resource_server
  belongs_to :resource

  validates :resource_id, uniqueness: { scope: [:resource_server_id, :user_id] }
end
