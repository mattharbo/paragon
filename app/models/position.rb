class Position < ApplicationRecord
    has_many :selection, dependent: :destroy
end
