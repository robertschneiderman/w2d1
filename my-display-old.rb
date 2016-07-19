require 'colorize'
require_relative 'cursorable'

class Display

  include Cursorable

  def initialize
    @cursor_pos=[0,0]
    @selected=false
  end






end
