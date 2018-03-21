require_relative 'Display.rb'
require_relative 'Board.rb'
require_relative 'HumanPlayer.rb'
class Game

  def initialize
    @board = Board.new()
    @display = Display.new(@board)

    @players = {
      white: HumanPlayer.new(:white, @display),
      black: HumanPlayer.new(:black, @display)
    }

    @turn = :white
    @not = :black
  end

  def play
    until @board.checkmate?(@turn)

      begin
        @players[@turn].make_move(@board)

        swap_turn
      rescue StandardError => e
        @display.notifications[:error] = e.message
        retry
      end
    end
    puts "#{@not} player has won!"
  end

  private
  def swap_turn
    if @turn == :white
      @turn = :black
      @not = :white
    else
      @turn = :white
      @not = :black
    end
  end
end

if __FILE__==$PROGRAM_NAME
  game = Game.new

  game.play
end
