class Movetype < ApplicationRecord
	has_many :moves, dependent: :destroy
end
