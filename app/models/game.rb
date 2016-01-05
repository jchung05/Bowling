class Game < ActiveRecord::Base
  has_many :scores, dependent: :destroy

  after_create :init

  def init
    self.index = 0
    self.frameArray = Array.new(20,-1)
    self.save
  end

  def exists
    self.index != -1
  end 

  def indexInc
    self.index += 1
  end

  def clearScore
    self.init
    self.score = 777
  end

  def bowl
    if self.exists
      if self.index < 20
        
        self.indexInc
#        self.frameArray[self.index] = self.index + 1
        self.score = self.index + self.score
      else
        self.index = -1
      end
    end
  end

  def getFrame
    if self.index == -1
        "Game Over"
    elsif self.index > 18
        10
    else
        self.index / 2 + 1
    end
  end

  def getAttempt
    if self.index == -1
        "-"
    elsif self.index > 18
        ( self.index - 17 )
    else
        self.index % 2 + 1
    end
  end
end
