require 'gosu'
require './constants'
require './input_functions'
require './track_handler'

class PlayerInterface < Gosu::Window
  def initialize(width, height, is_full_screen, caption, album_number)
    super(width, height, is_full_screen)
    self.caption = caption
    @width = width
    @height = height
    @sel_width = @width - 100
    @sel_height = @height - 200
    @albums = read_albums('./albums.txt')
    @small_font = Gosu::Font.new(11)
    @mid_font = Gosu::Font.new(13)
    @big_font = Gosu::Font.new(15)
    @avail_tracks = @albums[album_number]["tracks"]
    @curr_album_number = album_number
    @hover_selector = nil
    puts(@avail_tracks)
  end

  def draw_background()
    @big_font.draw("Back <<", 20, 10, Const::ZOrder::MIDDLE, 1.5, 1.5, Gosu::Color::WHITE)
    @big_font.draw("Choose 1 on #{@avail_tracks.length} songs below to play", 81, 50, Const::ZOrder::MIDDLE, 2.0, 2.0, Gosu::Color::WHITE)
    Gosu.draw_rect(0, 0, Const::Window::WIDTH, Const::Window::HEIGHT, Const::Color::MID_BLUE, Const::ZOrder::BACKGROUND, mode = :default)
    @swin_logo = Gosu::Image.new("./src/images/SwinburneLogo.bmp")
    @swin_logo.draw(230, 725, Const::ZOrder::MIDDLE, 0.1, 0.1)
  end

  def mouse_hover?(mX, mY)
    # Back (8) (20,15) -> (95, 26)
    selector = nil
    if(mX >= 0 && mX <= @width) && (mY >= 0 && mY <= @height)
      if(mX >= 20 && mX <= 95) && (mY >= 15 && mY <= 26)
        selector = 8
      end
    else
      selector = nil
    end
    return selector
  end

  def draw_player()
    init_x = 175
    init_y = 440
    Gosu.draw_rect(45, 110, @sel_width, @sel_height, Gosu::Color::WHITE, Const::ZOrder::MIDDLE, mode = :default)
    @album_image = Gosu::Image.new(@albums[@curr_album_number]["album"].image)
    case @curr_album_number
    when 0
      @big_font.draw("#{@albums[@curr_album_number]["album"].title} by #{@albums[@curr_album_number]["album"].artist}", 210, 150, Const::ZOrder::TOP, 2.0, 2.0, Gosu::Color::BLACK)
      @album_image.draw(190, 180, Const::ZOrder::TOP, 0.2, 0.2)
    when 1
      @big_font.draw("#{@albums[@curr_album_number]["album"].title} by #{@albums[@curr_album_number]["album"].artist}", 130, 150, Const::ZOrder::TOP, 2.0, 2.0, Gosu::Color::BLACK)
      @album_image.draw(200, 200, Const::ZOrder::TOP, 0.3, 0.3)
    when 2
      @big_font.draw("#{@albums[@curr_album_number]["album"].title} by #{@albums[@curr_album_number]["album"].artist}", 145, 150, Const::ZOrder::TOP, 2.0, 2.0, Gosu::Color::BLACK)
      @album_image.draw(190, 190, Const::ZOrder::TOP, 0.4, 0.4)
    when 3
      @big_font.draw("#{@albums[@curr_album_number]["album"].title} by #{@albums[@curr_album_number]["album"].artist}", 90, 150, Const::ZOrder::TOP, 2.0, 2.0, Gosu::Color::BLACK)
      @album_image.draw(185, 190, Const::ZOrder::TOP, 0.18, 0.18)
    end
    @album_frame = Gosu::Image.new("./src/images/FrameFour.bmp")
    @album_frame.draw(170, 430, Const::ZOrder::TOP, 0.4, 0.4)
    @big_font.draw("Now playing:\n#{Const::Tracks::NOTHING}", 170, 550, Const::ZOrder::TOP, 1.5, 1.5, Gosu::Color::BLACK)

    for i in @avail_tracks
      @big_font.draw(i.name, init_x, init_y, Const::ZOrder::TOP, 1, 1, Gosu::Color::BLACK)
      init_y += 25
    end

    @album_button = Gosu::Image.new("./src/images/Button.bmp")
    @album_button.draw(140, 600, Const::ZOrder::TOP, 0.5, 0.5)


  end

  #/////////////////////////////// DEFAULT TRIGGERING FUNCTIONS ////////////////////////////////

  def draw()
    draw_background()
    draw_player()

    #Debugger
    @small_font.draw("mX: #{mouse_x}", 200, 790, Const::ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
    @small_font.draw("mY: #{mouse_y}", 300, 790, Const::ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
  end

  def update()
  end

  def needs_cursor?
    true
  end

  def button_down(id)
    case id
    when Gosu::MsLeft
      @hover_selector = mouse_hover?(mouse_x, mouse_y)
      case @hover_selector
      when 8
        puts("Returning back to main GUI")
        close
        AlbumInterface.new(Const::Window::WIDTH, Const::Window::HEIGHT, Const::Window::NOT_FULL_SCREEN, Const::Window::TITLE).show() if __FILE__ == $0
      end
    end
  end
end

class AlbumInterface < Gosu::Window
  def initialize(width, height, is_full_screen, caption)
    super(width, height, is_full_screen)
    self.caption = caption
    @sel_width = width - 100
    @sel_height = height - 200
    @albums = read_albums('./albums.txt')
    @small_font = Gosu::Font.new(11)
    @mid_font = Gosu::Font.new(13)
    @big_font = Gosu::Font.new(15)
    @hovered_album = nil
    @is_hovering_album = false
    @album_image = nil
    puts(@albums)
  end

  def draw_background()
    @big_font.draw("Choose 1 on #{@albums.length} albums below to play", 81, 50, Const::ZOrder::MIDDLE, 2.0, 2.0, Gosu::Color::WHITE)
    Gosu.draw_rect(0, 0, Const::Window::WIDTH, Const::Window::HEIGHT, Const::Color::MID_BLUE, Const::ZOrder::BACKGROUND, mode = :default)
    @swin_logo = Gosu::Image.new("./src/images/SwinburneLogo.bmp")
    @swin_logo.draw(230, 725, Const::ZOrder::MIDDLE, 0.1, 0.1)
  end

  def mouse_hover?(mX, mY)
    # Album 1: (70,140) -> (270, 340) -> width 200, height 200 for all
    # Album 2: (310, 140) -> (515, 340)
    # Album 3: (70, 433) -> (270, 630)
    # Album 4: (310, 430) -> (510, 630)
    album_selection = Const::Album::NOTHING
    if (mX >= 70 && mX <= 515) && (mY >= 140 && mY <= 630)
      if (mX >= 70 && mX <= 270) && (mY >= 140 && mY <= 340)
        album_selection = Const::Album::FIRST
      end
      if (mX >= 310 && mX <= 515) && (mY >= 140 && mY <= 340)
        album_selection = Const::Album::SECOND
      end
      if (mX >= 70 && mX <= 270) && (mY >= 433 && mY <= 630)
        album_selection = Const::Album::THIRD
      end
      if (mX >= 310 && mX <= 510) && (mY >= 430 && mY <= 630)
        album_selection = Const::Album::FOURTH
      end
    else
      album_selection = Const::Album::NOTHING
    end
    return album_selection
  end

  def draw_selector()
    Gosu.draw_rect(45, 110, @sel_width, @sel_height, Gosu::Color::WHITE, Const::ZOrder::MIDDLE, mode = :default)
    @hovered_album = mouse_hover?(mouse_x, mouse_y)
    if @is_hovering_album
      case @hovered_album
      when 0
        Gosu.draw_rect(68,139, 204, 204, Gosu::Color::BLACK, Const::ZOrder::MIDDLE, mode = :default)
      when 1
        Gosu.draw_rect(308, 138, 206, 206, Gosu::Color::BLACK, Const::ZOrder::MIDDLE, mode = :default)
      when 2
        Gosu.draw_rect(68,431, 204, 204, Gosu::Color::BLACK, Const::ZOrder::MIDDLE, mode = :default)
      when 3
        Gosu.draw_rect(308, 428, 204, 204, Gosu::Color::BLACK, Const::ZOrder::MIDDLE, mode = :default)
      end
    end
    @album_image = Gosu::Image.new(@albums[0]["album"].image)
    @album_image.draw(70, 140, Const::ZOrder::TOP, 0.2, 0.2)
    @big_font.draw("#{@albums[0]["album"].title} By #{@albums[0]["album"].artist} @ #{@albums[0]["album"].year}", 100, 370, 3, 1.0, 1.0, Gosu::Color::BLACK)
    @album_image = Gosu::Image.new(@albums[1]["album"].image)
    @album_image.draw(310, 140, Const::ZOrder::TOP, 0.32, 0.32)
    @big_font.draw("#{@albums[1]["album"].title} By #{@albums[1]["album"].artist} @ #{@albums[1]["album"].year}", 300, 370, 3, 1.0, 1.0, Gosu::Color::BLACK)
    @album_image = Gosu::Image.new(@albums[2]["album"].image)
    @album_image.draw(70, 430, Const::ZOrder::TOP, 0.4, 0.4)
    @big_font.draw("#{@albums[2]["album"].title} By #{@albums[2]["album"].artist} @ #{@albums[2]["album"].year}", 70, 650, 3, 1.0, 1.0, Gosu::Color::BLACK)
    @album_image = Gosu::Image.new(@albums[3]["album"].image)
    @album_image.draw(310, 430, Const::ZOrder::TOP, 0.167, 0.167)
    @big_font.draw("#{@albums[3]["album"].title} \n   By #{@albums[3]["album"].artist} @ #{@albums[3]["album"].year}", 345, 650, 3, 1.0, 1.0, Gosu::Color::BLACK)
  end


  #/////////////////////////////// DEFAULT TRIGGERING FUNCTIONS ////////////////////////////////

  def draw()
    draw_background()
    draw_selector()

    #Debugger
    @small_font.draw("mX: #{mouse_x}", 200, 790, Const::ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
    @small_font.draw("mY: #{mouse_y}", 300, 790, Const::ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
  end

  def update()
    if mouse_hover?(mouse_x, mouse_y) != nil
      @is_hovering_album = true
    else
      @is_hovering_album = false
    end
  end

  def needs_cursor?
    true
  end

  def button_down(id)
    case id
    when Gosu::MsLeft

      case @hovered_album
      when Const::Album::NOTHING
        puts("Not the right one")
      when Const::Album::FIRST
        puts("Pressed on album one")
        close
        PlayerInterface.new(Const::Window::WIDTH, Const::Window::HEIGHT, Const::Window::NOT_FULL_SCREEN, Const::Window::TITLE, Const::Album::FIRST).show() if __FILE__ == $0
      when Const::Album::SECOND
        puts("Pressed on album two")
        close
        PlayerInterface.new(Const::Window::WIDTH, Const::Window::HEIGHT, Const::Window::NOT_FULL_SCREEN, Const::Window::TITLE, Const::Album::SECOND).show() if __FILE__ == $0
      when Const::Album::THIRD
        puts("Pressed on album three")
        close
        PlayerInterface.new(Const::Window::WIDTH, Const::Window::HEIGHT, Const::Window::NOT_FULL_SCREEN, Const::Window::TITLE, Const::Album::THIRD).show() if __FILE__ == $0
      when Const::Album::FOURTH
        puts("Pressed on album fourth")
        close
        PlayerInterface.new(Const::Window::WIDTH, Const::Window::HEIGHT, Const::Window::NOT_FULL_SCREEN, Const::Window::TITLE, Const::Album::FOURTH).show() if __FILE__ == $0
      end

    end
  end

end

app = AlbumInterface.new(Const::Window::WIDTH, Const::Window::HEIGHT, Const::Window::NOT_FULL_SCREEN, Const::Window::TITLE)
app.show() if __FILE__ == $0
# music_app = PlayerInterface.new(Const::Window::WIDTH, Const::Window::HEIGHT, Const::Window::NOT_FULL_SCREEN, Const::Window::TITLE, 3)
# music_app.show() if __FILE__  == $0
