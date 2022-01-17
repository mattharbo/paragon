class Season < ApplicationRecord
    has_many :competseasons, dependent: :destroy
end
