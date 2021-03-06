class Selection < ApplicationRecord
  belongs_to :contract
  belongs_to :fixture
  belongs_to :substitute, class_name: 'Contract', optional: true
  belongs_to :position, optional: true
  has_many :event, dependent: :destroy
end

