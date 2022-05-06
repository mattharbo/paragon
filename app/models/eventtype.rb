class Eventtype < ApplicationRecord
	has_many :events, dependent: :destroy
end
