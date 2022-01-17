class Competseason < ApplicationRecord
  belongs_to :competition
  belongs_to :season
  has_many :fixtures, dependent: :destroy
end
