require 'singleton'

class Piece

  attr_accessor :position
  attr_reader :color, :symbol

  def initialize(pos, color, board)
    @position = pos
    @color = color
    @board = board
  end

  def to_s
    " #{self.symbol.to_s} "
  end

end

class NullPiece
  include Singleton

  attr_reader :color

  def to_s
    "   "
  end

  def color
    nil
  end

end

class King < Piece
  KING_DIFFS = [-1, 0, 1].repeated_permutation(2).to_a - [[0, 0]]

  def initialize(pos, color, board)
    super
    @symbol = :K
  end

end

class Knight < Piece
  KNIGHT_DIFFS = [-1, 1].product([-2, 2]) + [-2, 2].product([-1, 1])

  def initialize(pos, color, board)
    super
    @symbol = :n
  end

end

class Pawn < Piece
  def initialize(pos, color, board)
    super
    @symbol = :p
  end
end

class Rook < Piece
  def initialize(pos, color, board)
    super
    @symbol = :R
  end
end

class Queen < Piece
  def initialize(pos, color, board)
    super
    @symbol = :Q
  end
end

class Bishop < Piece
  def initialize(pos, color, board)
    super
    @symbol = :B
  end
end

knight_diffs =

module Stepable
  def moves(diffs)
    diffs.map do |diff|
      x ,y = @position
      x_diff, y_diff = diff
      [x+x_diff, y+y_diff]
    end
  end
end

module Slideable

  HORIZONTALS = [[-1, 0], [0, -1], [1, 0], [0, 1]]
  DIAGONALS = [[-1, -1], [-1, 1], [1, 1], [1, -1]]
  ALL_DIFFS = HORIZONTALS + DIAGONALS

  def moves(dir)

    if dir == 'horizontal'
      diffs = HORIZONTALS
    elsif diffs == 'diagonal'
      diffs = DIAGONALS
    else
      diffs = ALL_DIFFS
    end
    moves=[]
    diffs.map do |diff|
      pos = @position

      while @board[pos].nil?
        x ,y = pos
        x_diff, y_diff = diff
        pos=[x+x_diff, y+y_diff]
        break if @color == @board[pos].color ||
          @board.in_bounds?(pos)
        moves << pos
      end
    end
  end

end
