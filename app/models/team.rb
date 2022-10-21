class Team < ApplicationRecord
    has_many :contracts, dependent: :destroy
    has_many :fixtures, dependent: :destroy
    has_many :kits, dependent: :destroy
end