class Move < ApplicationRecord
  belongs_to :event
  belongs_to :movetype
  belongs_to :selection
end
