class ID3v2
  private

  @@log = "/tmp/id3_err.log"

  def setter(file, name, parameter)
    file = @path + file
    ext = File.extname(file)
    if ext == ".mp3"
      cmd = "#{@id3} --#{parameter} \"#{name}\" \"#{file}\" &> #{@@log}"
      system(cmd)
      err = File.open(@@log).read
      file = file[@path.length, file.length - 1]
      if err.to_s.include? "denied"
        return "Bot has no write permissions on file #{file}, no meta tags updated"
      end
      return "Metatag for file #{file} updated sucessfully"
    else
      return "Filetype #{ext} is not supported"
    end
  end

  public

  def initialize
    @id3 = "id3v2 "
    @find = "find $HOME/music/ -iname "
    @path = %x(cd $HOME/music/ && pwd)
    @path = @path.to_s[0, @path.to_s.length - 1] + "/"
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

  def setGenre(file, name)
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
