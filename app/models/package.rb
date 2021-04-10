class Package < ApplicationRecord
  validates :title, :sessions, presence: true
end
