
require './input_functions'
require './constants'

def read_track(name, location)
  return Track.new(name, location)
end

def read_tracks(file)
  tracks = Array.new()
  index = 0
  num_of_tracks = file.gets().chomp().to_i()
  while(index < num_of_tracks)
    track_name = file.gets().chomp()
    track_location = file.gets().chomp()
    tracks << read_track(track_name, track_location)
    index += 1
  end

  return tracks
end

def read_album(file)
  album_name = file.gets().chomp()
  album_artist = file.gets().chomp()
  album_release = file.gets().chomp().to_i()
  album_genre = file.gets().chomp().to_i()
  album_img_path = file.gets().chomp()

  return Album.new(album_name, album_artist, album_release, album_genre, album_img_path)
end

def print_album(album)
  puts("Album Name: #{album.title}")
  puts("Album Artist: #{album.artist}")
  puts("Album Release Date: #{album.year}")
  puts("Genre is #{album.genre}")
  puts("Image path is #{album.image}")
end

def print_track(track)
  puts(track.name)
  puts(track.location)
end

def print_tracks(tracks)
  for i in 0...tracks.length
    puts("\n")
    puts("Track no #{i}")
    print_track(tracks[i])
  end
end

def read_albums(f_path)
  albums = []
  if File.exist?(f_path)
    file = File.new(f_path, "r")
    num_of_albums = file.gets().chomp().to_i()
    index = 0
    while index < num_of_albums
      album = read_album(file)
      tracks = read_tracks(file)
      albums << {"id" => index + 1, "album" => album, "tracks" => tracks}
      index += 1
    end
    file.close()
  else
    raise StandardError("Could not Find a file, please try again")
  end
  return albums
end

def print_albums(albums)
  index = 0
  while index < albums.length
    puts("Album no #{albums[index]["id"]}")
    print_album(albums[index]["album"])
    print_tracks(albums[index]["tracks"])
    puts("\n")
    index += 1
  end
end



def dbg()
  albums = read_albums("albums.txt")
  print_albums(albums)
end

dbg() if __FILE__ == $0