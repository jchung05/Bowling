class Game < ActiveRecord::Base
  has_many :rolls, dependent: :destroy
  validates_presence_of :index, :score
  accepts_nested_attributes_for :rolls

  after_create :init

  def init
    self.index = 0

##    Set to 0 on final deploy
#    self.score = 0

#    self.index = 17
    21.times {
      roll = Roll.new
      roll.save
      self.rolls << roll
    }

    self.save
  end

  def exists?
    index != -1
  end 

  def over?
    index == 21
  end

  def indexInc
    if over?
      self.index = -1
    else
      self.index += 1
    end
  end

  def clearScore
    Roll.delete_all( "game_id = " + self.id.to_s )
    self.init
  end

  def bowl
    if exists?
      if self.index % 2 == 0 and self.index < 20
        self.rolls[index].pinsHit = rand(11)
#alwaysstrike	self.rolls[index].pinsHit = 10
        self.rolls[index].frameScore = self.rolls[index].pinsHit
        self.rolls[index+1].pinsLeft =  10 - self.rolls[index].pinsHit

        #score method for later
        self.score += rolls[index].frameScore

	if self.rolls[index].frameScore == 10 and self.index != 18
          indexInc
          indexInc
        else
          indexInc
        end
      elsif self.index % 2 == 1 and self.index < 20
        self.rolls[index].pinsHit = rand(self.rolls[self.index].pinsLeft + 1)
#alwaysspare        self.rolls[index].pinsHit = self.rolls[self.index].pinsLeft
        self.rolls[index].frameScore = self.rolls[index].pinsHit

        if self.index == 19 and self.rolls[index].pinsHit != self.rolls[19].pinsLeft
          indexInc
          indexInc
        else
          indexInc
        end
      #Extra roll on 10th frame
     elsif self.rolls[19].pinsLeft > 0 and self.rolls[19].pinsLeft == self.rolls[19].frameScore
        self.rolls[index].pinsHit = rand(self.rolls[19].pinsLeft + 1)
        self.rolls[20].frameScore = self.rolls[index].pinsHit
        self.rolls[index].pinsLeft = self.rolls[19].pinsLeft - self.rolls[index].pinsHit
        indexInc
      elsif self.rolls[19].pinsLeft == 0
        self.rolls[index].pinsHit = rand(11)
        self.rolls[20].frameScore = self.rolls[index].pinsHit
        self.rolls[index].pinsLeft = 10 - self.rolls[index].pinsHit
        indexInc
      end
    else
      self.index = -1
    end
  end

  def strike?

  end

  def spare?

  end

  def getName
    if name == ""
      "-----"
    else
       name
    end
  end

  def getFrame
    if !exists?
        "Game Over"
    elsif index > 18
        10
    else
        index / 2 + 1
    end
  end

  def getAttempt
    if !exists?
        "-"
#    elsif index > 18
#        ( index - 17 )
    elsif index != 20
        index % 2 + 1
    end
  end

  def getPinsHit
    if index == 21 and rolls[19].pinsHit != -1
      rolls[20].pinsHit.to_s + " pins"
    elsif rolls[index-1].pinsHit == -1
      "a strike"
    else
      rolls[index-1].pinsHit.to_s + " pins"
    end
  end
end
