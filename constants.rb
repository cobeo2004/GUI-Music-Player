# frozen_string_literal: true


module Const
  #ZOrder
  module ZOrder
    BACKGROUND, MIDDLE, TOP, ON_TOP_OF_THE_WORLD = *0..3
  end

  # Const Colors
  module Color
    MID_BLUE = 0xff_3195e7
    MILD_ORANGE = 0xff_de741c
    LIGHT_GREEN = 0xff_a4c3a2
    TRANSPARENCY = 0x64_ff0000
    BROWN = 0x64_654321
    TREE_GREEN = 0x64_2a7e19
    LIGHT_YELLOW = 0x64_ffffe0
    BLUE_COLA  = 0x64_0093e9
    PEARL_AQUA = 0x64_80D0C7
  end

  # Style for Window
  module Window
    WIDTH = 600
    HEIGHT = 800
    NOT_FULL_SCREEN = false
    TITLE = 'Music Player by Simon'
  end

  module Album
    NOTHING = nil
    FIRST, SECOND, THIRD, FOURTH = *0..3
  end

  module Tracks
    NOTHING = nil
    FIRST, SECOND, THIRD, FOURTH = *0..3
    PLAYING, PAUSING, STOPPING, NEXT_TRACK, PREV_TRACK = *4..8
    BACK = 9
    INSTRUCTION = 10
    INVALID = 69
  end
end



class Album
  attr_accessor :artist, :title, :year, :genre, :image

  def initialize(artist, title, year, genre, path_to_img)
    @artist = artist
    @title = title
    @year = year
    @genre = genre
    @image = path_to_img
  end
end

class Track
  attr_accessor :name, :location
  def initialize(name, location)
    @name = name
    @location = location
  end
end
