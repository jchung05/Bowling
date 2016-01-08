class Roll < ActiveRecord::Base
  belongs_to :game
  validates_presence_of :game_id, :frameScore

  def getFrameScore
    if frameScore == -1
      ""
    elsif frameScore == 0
      "-"
    elsif frameScore == pinsLeft and pinsLeft != 10
      "/"
    elsif frameScore == 10
      "X"
    else
      frameScore
    end
  end
end
