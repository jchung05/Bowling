class Game < ActiveRecord::Base
  has_many :rolls, dependent: :destroy
  validates_presence_of :index, :score
  accepts_nested_attributes_for :rolls

  after_create :init

  def init
    self.index = 0

##    Set to 0 on final deploy
##    self.score = 99

#    self.index = 17
    21.times {
      roll = Roll.new
      roll.pinsLeft = 10
      roll.frameScore = -1
      roll.save
      self.rolls << roll
    }

    self.save
  end

  def exists
    index == -1
  end 

  def over
    index == 21
  end

  def indexInc
    self.index += 1
  end

  def clearScore
    self.init
    self.score = 0
  end

  def bowl
    if !over
      self.score = self.index + self.score
      self.rolls[index].frameScore += self.index
      self.rolls[index].pinsLeft += self.index
      self.indexInc
    else
      self.index = -1
    end
  end

  def getName
    if name == ""
      "-----"
    else
       name
    end
  end

  def getFrame
    if over
        "Game Over"
    elsif index > 18
        10
    else
        index / 2 + 1
    end
  end

  def getAttempt
    if over
        "-"
    elsif index > 18
        ( index - 17 )
    else
        index % 2 + 1
    end
  end

  def getPinsLeft
    rolls[index-1].pinsLeft.to_s
  end
end
