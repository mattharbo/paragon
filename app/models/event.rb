class Event < ApplicationRecord
  belongs_to :selection
  belongs_to :team
  belongs_to :eventtype
end
