class Policy < ApplicationRecord
  belongs_to :user
  belongs_to :resource
  belongs_to :resource_server
end
