class Competition < ApplicationRecord
    has_many :competseasons, dependent: :destroy
end
