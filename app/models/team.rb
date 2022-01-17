class Team < ApplicationRecord
    has_many :contracts, dependent: :destroy
    has_many :fixtures, dependent: :destroy
end