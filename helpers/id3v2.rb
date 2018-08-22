
class ID3v2
  private

  def validate(string)
    !string.match(/\A[a-zA-Z0-9\-._\s:!'@{}()#;&]*\z/).nil?
  end

  public

  def initialize
    @cmd = "id3v2 "
    @find = "find $HOME/music/ -iname "
    @path = "$HOME/music/"
  end

  def setAlbum(file, name)
    if !validate(file)
      return "name/search string is not valid"
    end
    file = %x(#{@find} *#{file}*.mp3 -o -iname *#{file}*.opus | head -n1)
    if file.empty?
      return "Not such file found"
    else
      system(@cmd + "-A " + name + " " + file)
      return "Metatag updated sucessfully"
    end
  end

  def setArtist(file, name)
    if !validate(file)
      return "name/search string is not valid"
    end
    file = %x(#{@find} *#{file}*.mp3 -o -iname *#{file}*.opus | head -n1)
    if file.empty?
      return "Not such file found"
    else
      system(@cmd + "-a " + name + " " + file)
    end
  end

  def setComment(file, comment)
    if !validate(file)
      return "name/search string is not valid"
    end
    file = %x(#{@find} *#{file}*.mp3 -o -iname *#{file}*.opus | head -n1)
    if file.empty?
      return "Not such file found"
    else
      system(@cmd + "-c " + comment + " " + file)
    end
  end

  def setGenreNo(file, num)
    if !validate(file)
      return "name/search string is not valid"
    end
    file = %x(#{@find} *#{file}*.mp3 -o -iname *#{file}*.opus | head -n1)
    if file.empty?
      return "Not such file found"
    else
      system(@cmd + "-a " + name + " " + file)
    end
  end

  def setTitle(file, name)
    if !validate(file)
      return "name/search string is not valid"
    end
    file = %x(#{@find} *#{file}*.mp3 -o -iname *#{file}*.opus | head -n1)
    if file.empty?
      return "Not such file found"
    else
      system(@cmd + "-t " + namei + " " + file)
    end
  end

  def setTrackNo(file, num)
    if !validate(file)
      return "name/search string is not valid"
    end
    file = %x(#{@find} *#{file}*.mp3 -o -iname *#{file}*.opus | head -n1)
    if file.empty?
      return "Not such file found"
    else
      system(@cmd + "-T " + num.to_i + " " + file)
    end
  end

  def setYear(file, num)
    if !validate(file)
      return "name/search string is not valid"
    end
    file = %x(#{@find} *#{file}*.mp3 -o -iname *#{file}*.opus | head -n1)
    if file.empty?
      return "Not such file found"
    else
      system(@cmd + "-y " + num.to_i + " " + file)
    end
  end
end
