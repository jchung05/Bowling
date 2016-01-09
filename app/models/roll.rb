class Roll < ActiveRecord::Base
  belongs_to :game
  validates_presence_of :game_id, :frameScore
  default_scope order('created_at ASC')
  scope: recent, unscoped.order('created_at DESC')

   def getFrameScore
     if frameScore == -1
       ""
     elsif frameScore == 0
       "-"
     elsif pinsHit == pinsLeft and indexMod == 1
       "/"
     elsif frameScore == 10
       "X"
     else
       frameScore
     end
   end

  def getSubscore
    if subscore == -1
      ""
    else
      subscore
    end
  end
end
