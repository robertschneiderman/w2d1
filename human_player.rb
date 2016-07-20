class HumanPlayer
  attr_accessor :color

  # include

  def initialize(name, display)
    @name = name
    @display = display
  end

  def play_turn
    old_pos = @display.get_input
    until old_pos
      @display.render
      old_pos= @display.get_input
    end

    new_pos = @display.get_input
    until new_pos
      @display.render
      new_pos= @display.get_input
    end

    p [old_pos, new_pos]
  end

end
