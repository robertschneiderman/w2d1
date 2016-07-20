require 'singleton'

module Stepable
  def moves
    moves=[]
    @diffs.each do |diff|
      x ,y = @position
      x_diff, y_diff = diff
      new_pos=[x+x_diff, y+y_diff]
      next unless new_pos.all? { |coord| coord.between?(0,7)}
      moves << new_pos unless board[new_pos].color==self.color
    end
    moves
  end
end

module Slideable

  HORIZONTALS = [[-1, 0], [0, -1], [1, 0], [0, 1]]
  DIAGONALS = [[-1, -1], [-1, 1], [1, 1], [1, -1]]
  ALL_DIFFS = HORIZONTALS + DIAGONALS

  def moves

    if @dir == 'horizontal'
      diffs = HORIZONTALS
    elsif @dir == 'diagonal'
      diffs = DIAGONALS
    else
      diffs = ALL_DIFFS
    end

    moves=[]
    diffs.each do |diff|
      pos = @position
      while @board[pos].is_a?(NullPiece) || @board[pos] == self
        x ,y = pos
        x_diff, y_diff = diff
        pos=[x+x_diff, y+y_diff]
        break if !@board.in_bounds?(pos) || @color == @board[pos].color
        moves << pos
      end
    end

    # moves << [0, 1]

    moves
  end

end

class Piece

  attr_accessor :position, :board
  attr_reader :color, :symbol

  def initialize(pos, color, board)
    @position = pos
    @color = color
    @board = board
  end

  def to_s
    " #{self.symbol.to_s} "
  end

  def valid_moves
    moves.reject { |move| move_into_check?(move) }
  end

  def move_into_check?(end_pos)
    possible_board = @board.dup_board
    possible_board.move!( @position, end_pos)
    possible_board.in_check?(@color)
  end

end

class King < Piece
  include Stepable
  KING_DIFFS = [-1, 0, 1].repeated_permutation(2).to_a - [[0, 0]]

  def initialize(pos, color, board)
    @diffs=KING_DIFFS
    super
    @symbol = :K
  end

end

class Knight < Piece
  include Stepable
  KNIGHT_DIFFS = [-1, 1].product([-2, 2]) + [-2, 2].product([-1, 1])

  def initialize(pos, color, board)
    @diffs = KNIGHT_DIFFS
    super
    @symbol = :n
  end

end

class Pawn < Piece
  include Slideable
  def initialize(pos, color, board)
    super
    @symbol = :p

  end
end

class Queen < Piece
  include Slideable
  def initialize(pos, color, board)
    super
    @symbol = :Q
    @dir = 'all'
  end
end

class Rook < Piece
  include Slideable
  def initialize(pos, color, board)
    super
    @symbol = :R
    @dir = "horizontal"
  end
end

class Bishop < Piece
  include Slideable
  def initialize(pos, color, board)
    super
    @symbol = :B
    @dir = "diagonal"
  end
end

class NullPiece
  include Singleton

  attr_reader :color

  def symbol
    nil
  end

  def to_s
    "   "
  end

  def color
    nil
  end

end

# knight_diffs =
