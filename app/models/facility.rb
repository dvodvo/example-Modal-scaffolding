# TODO two
class Facility < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
end
