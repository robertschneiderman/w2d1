require_relative 'piece'
require_relative 'display'

class Board

  attr_reader :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) { NullPiece.instance } }
    p @grid
    populate_board
  end

  def populate_board
    pieces = [Rook, Knight, Bishop]
    pieces = pieces + [King, Queen] + pieces.reverse

    # top row
    [0].product((0..7).to_a).each_with_index do |pos, i|
      self[pos]=pieces[i].new(pos, 'black', @board)
    end
    [1].product((0..7).to_a).each do |pos|
      self[pos]=Pawn.new(pos, 'black', @board)
    end
    # bottom row
    [6].product((0..7).to_a).each do |pos|
      self[pos]=Pawn.new(pos, 'white', @board)
    end
    [7].product((0..7).to_a).each_with_index do |pos, i|
      self[pos]=pieces.reverse[i].new(pos, 'white', @board)
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
    @grid.flatten.select { |piece| piece.symbol == :K && piece.color == color }
  end

  def get_opposing_pieces(color)
    opposite_color = opposite_color(color)
    opposite_pieces = get_pieces(opposite_color)
  end

  def get_all_opposing_moves(color)
    opposing_pieces = get_opposing_pieces(color)
    moves = []
    opposite_pieces.each do |piece|
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
    begin
      # get_move
      raise "Not valid move" unless valid_move(start, end_pos)
    rescue
      piece = self[start]
      self[end_pos] = piece
      self[start] = NullPiece.instance
      piece.position = end_pos
    end
  end

  # def valid_move?(start, end_pos)
  #   start.nil?
  #   # need more criteria
  # end
  def dup_board(board)
      result=[]
      @board.map{|el| el.dup}
  end

  def in_bounds?(pos)
    pos.all? { |coord| coord.between(0, 7) }
  end

end

b = Board.new
# p b.grid
Display.new(b).render
