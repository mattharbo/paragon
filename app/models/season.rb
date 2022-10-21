class Season < ApplicationRecord
    has_many :competseasons, dependent: :destroy
    has_many :kits, dependent: :destroy
end
