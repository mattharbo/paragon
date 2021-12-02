class Fixture < ApplicationRecord
  belongs_to :hometeam
  belongs_to :awayteam
  belongs_to :competseason

  belongs_to :hometeam, :class_name => 'Team'
  belongs_to :awayteam, :class_name => 'Team'
end
