class Selection < ApplicationRecord
  belongs_to :contract
  belongs_to :fixture

  belongs_to :substitute, class_name: 'User'
end
