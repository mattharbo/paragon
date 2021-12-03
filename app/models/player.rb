class Player < ApplicationRecord
    has_many :contracts, dependent: :destroy
end
