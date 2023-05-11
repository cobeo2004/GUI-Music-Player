require 'gosu'
require './track_handler'

class App < Gosu::Window
  def initialize(width, height, caption, is_full_screen)
    super(width,height, is_full_screen)
    self.caption = caption
    @album = read_albums("./albums.txt")
    @playing_song = Gosu::Song.new(@album[0]["tracks"][0].location)
    @playing_song.play()
  end
end

app = App.new(640,480, "Con Cac", false)
app.show()