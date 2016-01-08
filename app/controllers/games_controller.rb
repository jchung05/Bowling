class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy, :bowl, :reset]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)
    @game.modIndex

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Function to bowl
  def bowl
    if !@game.over?
      @game.bowl!
      @game.totalScore!
 
      respond_to do |format|
        if @game.save
           if !@game.over?
             format.html { redirect_to @game, notice: 'You rolled ' + @game.getPinsHit.to_s + ', loser. Your current score is ' + @game.score.to_s }
           else
             format.html { redirect_to @game, notice: 'You rolled ' + @game.getPinsHit.to_s + ', loser. The game is over. Your final score was ' + @game.score.to_s + '. Good jorbs.' }
           end
          format.json { render :show, status: :ok, location: @game }
        else
          format.html { render :edit }
          format.json { render json: @game.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to @game, notice: 'The game is over. Good game!' }
        format.json { render :show, status: :ok, location: games_url }
      end
    end
  end

  # Function to reset game
  def reset
    @game.clearScore
    @game.modIndex

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: @game.getName + "'s score has been reset." }
        format.json { head :no_content }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:name, :score)
    end
end
