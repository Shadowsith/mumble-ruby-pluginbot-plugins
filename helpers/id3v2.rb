
class ID3v2
  private

  def setter(file, name, parameter)
    file = @path + file
    system(@cmd + "--#{parameter} " + name + " " + file)
    file = file.gsub(@path)
    return "Metatag for file #{file} updated sucessfully"
  end

  public

  def initialize
    @cmd = "id3v2 "
    @find = "find $HOME/music/ -iname "
    @path = "$HOME/music/"
  end

  def deleteAll(file, name)
    return setter(file, name, "delete-all")
  end

  def setAlbum(file, name)
    return setter(file, name, "album")
  end

  def setArtist(file, name)
    return setter(file, name, "artist")
  end

  def setComment(file, comment)
    return setter(file, name, "comment")
  end

  def setGenreNo(file, num)
    return setter(file, name, "genre")
  end

  def setTitle(file, name)
    return setter(file, name, "song")
  end

  def setTrackNo(file, num)
    return setter(file, num.to_s, "track")
  end

  def setYear(file, num)
    return setter(file, num.to_s, "year")
  end
end
