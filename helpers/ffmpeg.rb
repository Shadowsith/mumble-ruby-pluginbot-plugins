class FFmpeg
  private
  @@ffmpeg = "ffmpeg -hide_banner -loglevel panic "

  def isTypeValid(ftype)
    for type in @ftype
      return true if ftype == type
    end
    return false
  end

  # TODO must be finished
  def initFtypes
    @ftype = Array.new
    @ftype.push("mp3");
    @ftype.push("m4a");
    @ftype.push("opus");
    @ftype.push("ogg");
  end
    
  public 

  def initialize(song)
    @file = song.file
    @type = File.extname(song.file)
    @length = song.length
  end

  def convert(new_type)
    if isTypeValid(@type) && isTypeValid(new_type)

    else
      return "type not valid"
    end
  end

  def cutHead(until_to)
    if isTypeValid(@type)
      if until_to < @length
        cut = "-y -ss #{until_to} -i #{@file} -acodec copy #{@file}"
        system{@@ffmpeg + cut}
      end
    end
  end
  
  def cutTail(from)
    if isTypeValid(@type)
      tail = @length-from
      if tail > 0
        cut = "-y -t #{tail} -i #{@file} -acodec copy #{@file}"
        system{@@ffmpeg + cut}
      end
    end
  end

  def cutCenter(from, to)
    if isTypeValid(@type)

    end
  end

  def printSupportedTypes
    types = ""
    for t in @type 
      types += ", #{t}"
    end
    return " #{types}"
  end
end
