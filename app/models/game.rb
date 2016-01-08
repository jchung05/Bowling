class Game < ActiveRecord::Base
  has_many :rolls, dependent: :destroy
  validates_presence_of :index, :score
  accepts_nested_attributes_for :rolls

  after_create :init

  def init
    self.index = 0
    self.score = 0

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

  def bowl!
    if exists?
      if self.index % 2 == 0 and self.index < 20 #first rolls
        self.rolls[self.index].pinsHit = rand(11)
#alwaysstrike	self.rolls[self.index].pinsHit = 10
        self.rolls[self.index].frameScore = self.rolls[self.index].pinsHit
        self.rolls[self.index+1].pinsLeft =  10 - self.rolls[self.index].pinsHit

	if self.rolls[self.index].frameScore == 10 and self.index != 18
          indexInc
          indexInc
        elsif self.rolls[self.index].frameScore == 10 and self.index == 18
          indexInc
          self.rolls[self.index].pinsLeft = 10
        else
          indexInc
        end

      elsif self.index % 2 == 1 and self.index < 20 #second rolls
        self.rolls[self.index].pinsHit = rand(self.rolls[self.index].pinsLeft + 1)
#alwaysspare        self.rolls[index].pinsHit = self.rolls[self.index].pinsLeft
        self.rolls[self.index].frameScore = self.rolls[index].pinsHit

        if self.rolls[18].frameScore == 10 and spare?( index )
          self.rolls[20].pinsLeft = 10
        elsif self.rolls[18].frameScore == 10 and !spare?( index )
          self.rolls[20].pinsLeft = 10 - self.rolls[index].pinsHit
        end
        if index == 19 and ( self.rolls[18].pinsHit + self.rolls[19].pinsHit < 10 )
          indexInc
          indexInc
        else
          indexInc
        end

#Extra roll on 10th frame
      elsif strike?(18) or ( spare?(19) or strike?(19) ) #if your second roll is not a spare or strike
        self.rolls[20].pinsHit = rand( 10 - self.rolls[19].pinsHit + 1 )
        self.rolls[20].frameScore = self.rolls[20].pinsHit
        self.rolls[20].pinsLeft = self.rolls[19].pinsLeft - self.rolls[20].pinsHit
        indexInc
      elsif self.rolls[19].pinsLeft == 0 #if your second roll is a spare or strike
        self.rolls[20].pinsHit = rand(11)
        self.rolls[20].frameScore = self.rolls[20].pinsHit
        self.rolls[20].pinsLeft = 10 - self.rolls[20].pinsHit
        indexInc
      end
    else
      self.index = -1
    end
  end

  def totalScore! #( idx )
    self.score = 0
    maxidx = 21
    (0...maxidx).each do |num|
#      self.score += num
      if strike?( num )
        if num >= 18
          strike!( num,2 )
        else
          strike!( num,4 )
        end
      elsif spare?( num )
        spare!( num )
      elsif self.rolls[num].frameScore != -1
        self.score += self.rolls[num].frameScore
      end
    end
    self.rolls[index-1].subscore = self.score
  end

  def strike?( x )
    self.rolls[x].frameScore == 10
  end

  def spare?( x )
    ( self.rolls[x].pinsHit + self.rolls[x-1].pinsHit == 10 ) and ( x % 2 == 1 or x == 20 )
  end

  def strike!( idx, limit )
    flag = 0
    specialScore = self.rolls[idx].frameScore #10
    (1..limit).each do |a|
      if self.rolls[idx+a].frameScore != -1 and flag < 2
        specialScore += self.rolls[idx+a].frameScore
        flag += 1
      end
    end
    if flag < 2
      self.score += 0
    else
      self.score += specialScore
    end
  end

  def spare!( idx )
    specialScore = self.rolls[idx].frameScore
    if self.rolls[idx+1].frameScore != -1
      specialScore += self.rolls[idx+1].frameScore
      self.score += specialScore
    else
      self.score += 0
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
    if over?
        "Game Over"
    elsif index > 18
        10
    else
        index / 2 + 1
    end
  end

  def getAttempt
    if over?
        "-"
    elsif index == 20
        3
    elsif index != 20
        index % 2 + 1
    end
  end
 
  def getPinsHit
    if index == 2 and self.rolls[0].frameScore == 10
      "a strike"
    elsif rolls[index-1].pinsHit == 0
      "a gutter ball"
    elsif strike?(index-2) and index != 20
      "a strike"
    elsif rolls[index-1].pinsHit == 1
      "a pin"
    elsif index == 20
      rolls[index-1].pinsHit.to_s + " pins"
    elsif spare?(index-1)
      "a spare"
    elsif index == 21 and self.rolls[18].frameScore == 10
      rolls[20].pinsHit.to_s + " pins"
    elsif index == 21 and self.rolls[18].frameScore != 10
      rolls[19].pinsHit.to_s + " pins"
    else
      rolls[index-1].pinsHit.to_s + " pins"
    end
  end

#quickfix
  def modIndex
    (0..20).each do |x|
      if x % 2 == 1
        self.rolls[x].indexMod = 1
      else
        self.rolls[x].indexMod = 0
      end
    end
  end
end
