require_relative 'Cursor.rb'
class HumanPlayer
  def initialize(color, display)
    @color = color
    @display = display
  end

  def make_move(board)
    start_pos = nil
    end_pos = nil
    @display.render
    until start_pos.is_a?(Array) && start_pos.length == 2
      start_pos = @display.cursor.get_input
      @display.render
    end
    until end_pos.is_a?(Array) && end_pos.length == 2
      end_pos = @display.cursor.get_input
      @display.render
    end
    board.move_piece(start_pos, end_pos, @color)
  end


end
