class Competition < ApplicationRecord
    has_many :competseason, dependent: :destroy
end
