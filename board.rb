require_relative 'piece'
require_relative 'display'

class Board

  attr_accessor :grid

  def initialize(grid = nil)
    @grid = grid
    grid ||= populate_board
  end

  def populate_board
    @grid = Array.new(8) { Array.new(8) { NullPiece.instance } }

    pieces = [Rook, Knight, Bishop]
    pieces = pieces + [King, Queen] + pieces.reverse

    # top row
    [0].product((0..7).to_a).each_with_index do |pos, i|
      self[pos]=pieces[i].new(pos, 'black', self)
    end

    [1].product((0..7).to_a).each do |pos|
      self[pos]=Pawn.new(pos, 'black', self)
    end
    # bottom row
    [6].product((0..7).to_a).each do |pos|
      self[pos]=Pawn.new(pos, 'white', self)
    end
    [7].product((0..7).to_a).each_with_index do |pos, i|
      self[pos]=pieces.reverse[i].new(pos, 'white', self)
    end

  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, mark)
    x, y = pos
    @grid[x][y]=mark
  end

  def in_check?(color)
    king = get_king(color)
    moves = get_all_opposing_moves(color)
    moves.include?(king.position)
  end

  def checkmate?(color)
    return false unless in_check?(color)
    king = get_king(color)
    opposing_moves=get_all_opposing_moves(color)
    king.moves.all? { |move| opposing_moves.include?(move) }
  end

  def get_king(color)
    @grid.flatten.find { |piece| piece.symbol == :K && piece.color == color }
  end

  def get_opposing_pieces(color)
    opposite_color = opposite_color(color)
    opposite_pieces = get_pieces(opposite_color)
  end

  def get_all_opposing_moves(color)
    opposing_pieces = get_opposing_pieces(color)
    moves = []
    opposing_pieces.each do |piece|
      moves += piece.moves
    end
    moves
  end

  def get_pieces(color)
    @grid.flatten.select{|piece| piece.color == color }
  end

  def opposite_color(color)
    opposite_color = color == 'black' ? 'white' : 'black'
  end

  def move(start, end_pos)
    piece = self[start] if self[start].color
    valid_moves = piece.valid_moves
    unless valid_moves.include?(end_pos)
      raise "Not valid move"
    end

    self[end_pos] = piece
    self[start] = NullPiece.instance
    piece.position = end_pos

    @grid.flatten.each{|piece| piece.board=self unless piece.is_a?(NullPiece)}
  end

  def move!(start, end_pos)
    piece = self[start]
    self[end_pos] = piece
    self[start] = NullPiece.instance
    piece.position = end_pos
  end
  # def valid_move?(start, end_pos)
  #   start.nil?
  #   # need more criteria
  # end
  def dup_board
    duped_grid = Board.deep_dup(@grid)
    duped_board=Board.new(duped_grid)
  end

  def self.deep_dup(grid)
    duped_array = []

    grid.each do |item|
      if item.is_a?(Array)
        duped_array << deep_dup(item)
      elsif item.is_a?(NullPiece)
        duped_array << item
      else
        duped_array << item.dup
      end
    end

    duped_array
  end

  def in_bounds?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

end

# arr1 = [1, 2, [3, 4]]
#
# arr2 = arr1.deep_dup
#
# p arr1[2].object_id == arr2[2].object_id

# b = Board.new
# Display.new(b, true).render
