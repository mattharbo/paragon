class Season < ApplicationRecord
    has_many :competseason, dependent: :destroy
end
