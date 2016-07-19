require "colorize"
require_relative "cursorable"

class Display
  include Cursorable

  def initialize(board, debug = false)
    @board = board
    @cursor_pos = [0, 2]
    @debug = debug
  end

  def build_grid
    @board.grid.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      piece.to_s.colorize(color_options)
    end
  end

  def colors_for(i, j)
    if [i, j] == @cursor_pos
      bg = :light_red
    elsif (i + j).odd?
      bg = :light_blue
    else
      bg = :blue
    end
    { background: bg, color: :white }
  end

  def render
    system("clear")
    puts "Fill the grid!"
    puts "Arrow keys, WASD, or vim to move, space or enter to confirm."
    build_grid.each { |row| puts row.join }
    if @debug
      selected_piece = @board[@cursor_pos]
      puts "Available moves for current piece:"
      puts "#{selected_piece.moves}"
      puts "White king in check" if @board.in_check?('white')
      puts "Black king in check" if @board.in_check?('black')
    end
  end
end
