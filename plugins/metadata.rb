require "../helpers/id3v2.rb"

class Metadata < Plugin
  private

  @@id3 = ID3v2.new

  def getTags(file)
    song = @@bot[:mpd].songs.select { |s| s.file.to_s.downcase.include? file.to_s.downcase }.first
    if !song.nil?
      meta = ""
      meta = "<br>Title:  #{song.title}" if !song.title.to_s.empty?
      meta += "<br>Artist:  #{song.artist}" if !song.artist.to_s.empty?
      meta += "<br>Album:  #{song.artist}" if !song.album.to_s.empty?
      meta += "<br>Genre:  #{song.genre}" if !song.genre.to_s.empty?
      meta += "<br>Date:  #{song.date}" if !song.date.to_s.empty?
      meta += "<br>File:  #{song.file}" if !song.file.to_s.empty?
      meta += "<br>Length:  #{song.track_length}s<br>" if !song.track_length.to_s.empty?
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
    h << "<b>#{Conf.gvalue("main:control:string")}meta [title|artist|album|track|year|comment] [file] [value] - add/change metadata from audiofiles<br>"
    h << "<b>#{Conf.gvalue("main:control:string")}metadata [file] - show metadata from audiofiles<br>"
    h
  end

  def handle_chat(msg, message)
    super
    parts = message.split(" ")
    begin
      if parts[0] == "metadata"
        getTags(parts[1]) if !parts[1].empty?
      end
      if parts[0] == "meta"
        tag = parts[1]
        file = parts[2]
        val = parts[3]
        if !tag.empty? && !file.empty? && !val.empty?
          song = @@bot[:mpd].songs.select { |s| s.file.to_s.downcase.include? file.to_s.downcase }.first
          if !song.nil?
            text = @@id3.setTitle(song.file, val) if tag == "title"
            text = @@id3.setAlbum(song.file, val) if tag == "album"
            text = @@id3.setArtist(song.file, val) if tag == "artist"
          else
            text = "No file found"
          end
          privatemessage(text)
        else
          privatemessage("Wrong number of paramerts!")
        end
      end
    rescue Exception => ex
      privatemessage("Metadata Error: #{ex.message}")
    end
  end
end
