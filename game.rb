require 'byebug'

require_relative 'display'
require_relative 'board'
require_relative 'human_player'

class Game

  def initialize
    @board = Board.new
    @display = Display.new(@board)

    @player1 ||= HumanPlayer.new('Rob', @display)
    @player2 ||= HumanPlayer.new('Ryan', @display)
    @player1.color = "white"
    @player2.color = "black"

    @player_order = [@player1, @player2]


    # @current_player = @player1
    play
  end

  def play
    while true
      @display.render(current_player)
      begin
        next_move = current_player.play_turn
        raise "not your piece" unless players_piece?(next_move)
        @board.move(*next_move)
      rescue
        puts $!
        retry
      end
      break if @board.checkmate?(other_player.color)
      switch_player!
    end
    Display.new(@board).render
    puts "#{current_player.name} wins!"
  end

  def switch_player!
    @player_order.rotate!
    # @current_player = (current_player == player1 ? player2 : player1)
  end

  def current_player
    @player_order.first
  end

  def other_player
    @player_order.last
  end

  def players_piece?(next_move)
    selected_pos = next_move[0]
    selected_piece=@board[selected_pos]
    selected_piece.color == current_player.color
  end

end

Game.new
