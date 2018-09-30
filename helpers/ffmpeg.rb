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
    @ftype.push(".mp3");
    @ftype.push(".m4a");
    @ftype.push(".opus");
    @ftype.push(".ogg");
  end
    
  public 

  # status codes for plugins 
  module Status
    SUCCESS = 0
    FTYPE = 1
    FLEN = 2
  end

  def initialize(song)
    @file = "~/music/\"#{song.file}\""
    @type = File.extname(song.file)
    @length = song.track_length
    @mv = " && mv #{@file}.#{@type} #{@file}"
    initFtypes
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
        cut = "-y -ss #{until_to} -i #{@file} -acodec copy #{@file}.#{@type}"
        system(@@ffmpeg + cut + @mv)
        return Status::SUCCESS
      else
        return Status::FLEN
      end
    else
      return Status::FTYPE
    end
  end
  
  def cutTail(start_time)
    if isTypeValid(@type)
      tail = @length-start_time
      if tail > 0
        cut = "-y -t #{tail} -i #{@file} -acodec copy #{@file}.#{@type}"
        system{@@ffmpeg + cut + @mv}
        return Status::SUCCESS
      else
        return Status::FLEN
      end
    else
      return Status::FTYPE
    end
  end

  def cutCenter(start_time, duration)
    if isTypeValid(@type)
      if @length > (start_time + duration)
        cut = "-y -ss #{start_time} -t #{duration} -i #{@file} -acodec copy #{@file}.#{@type}"
        system{@@ffmpeg + cut + @mv}
      else
        return Status::FLEN
      end
    else
      return Status::FTYPE
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
