class Event < ApplicationRecord
  belongs_to :selection
  belongs_to :eventtype
  has_many :eventtags, dependent: :destroy
  has_many :moves, dependent: :destroy
end
