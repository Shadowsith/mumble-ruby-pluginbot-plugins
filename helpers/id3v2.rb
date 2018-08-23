
class ID3v2
  private

  def validate(string)
    !string.match(/\A[a-zA-Z0-9\-._\s:!'@{}()#;&]*\z/).nil?
  end

  def setter(file, name, parameter)
    if !validate(file)
      return "name/search string is not valid"
    end
    file = %x(#{@find} *#{file}*.mp3 -o -iname *#{file}*.opus | head -n1)
    if file.empty?
      return "No such file found"
    else
      system(@cmd + "--#{parameter} " + name + " " + file)
      file = file.gsub(@cut)
      return "Metatag for file #{file} updated sucessfully"
    end
  end

  public

  def initialize
    @cmd = "id3v2 "
    @find = "find $HOME/music/ -iname "
    @path = "$HOME/music/"
    @cut = %x("$HOME/music/")
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
