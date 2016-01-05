class Game < ActiveRecord::Base
  has_many :scores, dependent: :destroy

  after_create :init

  def init
    
  end	
end
