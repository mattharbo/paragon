class Tag < ApplicationRecord
	has_many :eventtags, dependent: :destroy
end
