class Contract < ApplicationRecord
  belongs_to :team
  belongs_to :player
  has_many :selections, dependent: :destroy
end
