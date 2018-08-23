require "../helpers/id3v2.rb"

class Metadata < Plugin
  private

  def getTags(file)
    song = @@bot[:mpd].songs.select { |s| s.file.to_s.downcase.include? file.to_s.downcase }.first
    if !song.nil?
      meta = ""
      meta = "<br>Title:  #{song.title}<br>" if !song.title.to_s.empty?
      meta += "Artist:  #{song.artist}<br>" if !song.artist.to_s.empty?
      meta += "Album:  #{song.artist}<br>" if !song.album.to_s.empty?
      meta += "Genre:  #{song.genre}<br>" if !song.genre.to_s.empty?
      meta += "Date:  #{song.date}<br>" if !song.date.to_s.empty?
      meta += "File:  #{song.file}<br>" if !song.file.to_s.empty?
      meta += "Length:  #{song.track_length}s<br>" if !song.track_length.to_s.empty?
      privatemessage(meta)
    else
      privatemessage("No file with pattern #{file} found")
    end
  end

  public

  def init(init)
    super
    logger("INFO: INIT plugin #{self.class.name}.")
    @@bot[:bot] = self
    return @@bot
  end

  def name
    self.class.name
  end

  def help(h)
    h << "<hr><span style='color:red;'>Plugin #{self.class.name}</span><br>"
    h << "<b>#{Conf.gvalue("main:control:string")}meta [title|artist|album|track|year|comment] [value] [file] - add/change metadata from audiofiles<br>"
    h << "<b>#{Conf.gvalue("main:control:string")}metadata [file] - show metadata from audiofiles<br>"
    h
  end

  def handle_chat(msg, message)
    super
    parts = message.split(" ")
    begin
      if parts[0] == "metadata"
        if !parts[1].empty?
          getTags(parts[1])
        end
      end
    rescue Exception => ex
      privatemessage("Metadata Error: #{ex.message}")
    end
  end
end
