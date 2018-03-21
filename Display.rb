require 'byebug'
require_relative 'Board.rb'
require 'colorize'
require_relative 'Cursor.rb'

class Display
  attr_reader :cursor, :notifications
  def initialize(board)
    @cursor = Cursor.new([0,0], board)
    @board = board
    @notifications = {}
  end

  def render
    @notifications[:errors] = nil
    system('clear')
    @board.rows.each_with_index do |row, i|

      row.each_with_index do |piece, j|
        if piece.color == :white
          str = piece.to_s.colorize(:white)
        elsif piece.color == :black
          str = piece.to_s.colorize(:yellow)
        else
          str = piece.to_s
        end
        if i % 2 == 0
          if j % 2 == 0
            str = str.colorize(background: :red)
          else
            str = str.colorize(background: :blue)
          end
        else
          if j.odd?
            str = str.colorize(background: :red)
          else
            str = str.colorize(background: :blue)
          end
        end

        str = str.colorize(background: :green) if [i, j] == @cursor.cursor_pos
        print str
      end
      puts
    end

    @board.rows.each_with_index do |row, i|
      row.each_with_index do |square, j|
      end
    end

    @notifications.each do |_key, val|
      puts val
    end
  end

end
