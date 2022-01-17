class Position < ApplicationRecord
    has_many :selections, dependent: :destroy
end
