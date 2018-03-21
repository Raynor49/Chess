require_relative 'Piece.rb'
require 'byebug'
class Board
  attr_reader :rows
  def initialize(new_layout=true)
    @rows = Array.new(8) { Array.new(8) }
    @sentinel = NullPiece.instance
    if new_layout
      self.fill_board
    end

  end

  def add_piece(type, color, pos)
    self[pos] = type.new(color, self, pos)
  end

  def fill_board()
    @rows.map!.with_index do |row,idx|
      row.map!.with_index do |col,idx2|
        if idx == 1
          Pawns.new(:black, self, [idx,idx2])
        elsif idx == 6
          Pawns.new(:white, self, [idx,idx2])
        elsif idx == 0
          if idx2 == 0 || idx2 == 7
            Rook.new(:black, self, [idx,idx2])
          elsif idx2 == 1 || idx2 == 6
            Knight.new(:black, self, [idx,idx2])
          elsif idx2 == 2 || idx2 == 5
            Bishop.new(:black, self, [idx,idx2])
          elsif idx2 == 3
            Queen.new(:black, self, [idx,idx2])
          else
            King.new(:black,self,[idx,idx2])
          end
        elsif idx == 7
          if idx2 == 0 || idx2 == 7
            Rook.new(:white, self, [idx,idx2])
          elsif idx2 == 1 || idx2 == 6
            Knight.new(:white, self, [idx,idx2])
          elsif idx2 == 2 || idx2 == 5
            Bishop.new(:white, self, [idx,idx2])
          elsif idx2 == 3
            Queen.new(:white, self, [idx,idx2])
          else
            King.new(:white,self,[idx,idx2])
          end
        else
          @sentinel
        end
      end
    end
  end

  def [](pos)
    row,col = pos
    self.rows[row][col]
  end

  def []=(pos,val)
    row,col = pos
    self.rows[row][col] = val
  end

  def move_piece(start_pos,end_pos, player_color)
    piece = self[start_pos]

    raise NoPieceError if self[start_pos].color.nil?
    raise InvalidMoveError unless piece.valid_move?(end_pos, player_color)
    self[end_pos] = self[start_pos]
    self[start_pos] = @sentinel
    self[end_pos].pos = end_pos
  end

  def move_piece!(start_pos,end_pos)
    self[end_pos] = self[start_pos]
    self[start_pos] = @sentinel
    self[end_pos].pos = end_pos
  end

  def valid_pos(pos)
    pos.all? {|n| -1 < n && n < 8}
  end

  def pieces
    result = @rows.flatten.reject do |square|
      square.color.nil?
    end
  end

  def find_king(color)
    king_pos = nil
    self.pieces.each do |piece|
      if piece.class == King && piece.color.to_s == color
        king_pos = piece.pos
      end
    end
    king_pos
  end

  def in_check?(color)
    # king_pos = find_king(color)
    # pieces.any? do |p|
    #   p.color != color && p.moves.include?(king_pos)
    # end

    king_pos = self.find_king(color)
    pieces = self.pieces
    self.pieces.any? do |piece|
      piece.moves.include?(king_pos) && piece.color.to_s != color
    end
  end

  def checkmate?(color)
    # return false unless in_check?(color)
    #
    # pieces.all? do |piece|
    #   piece.valid_moves(color).empty?
    # end
    my_pieces = self.pieces.select {|piece| piece.color.to_s == color.to_s}
    no_moves = my_pieces.none? do |piece|
      piece.moves.length > 0
    end
    self.in_check?(color.to_s)
  end

end

class InvalidMoveError < StandardError
  def initialize(msg="That Piece Cannot Move There")
    super
  end
end

class NoPieceError < StandardError
  def initialize(msg="No Piece at Starting Location")
    super
  end
end
