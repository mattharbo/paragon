class Team < ApplicationRecord
    has_many :contracts, dependent: :destroy
end
