# This is a wrapper module for @@bot[:mpd] methods which requires more than one
# line

module IMpd
  private

  def timedecode(time)
    begin
      #Code from https://stackoverflow.com/questions/19595840/rails-get-the-time-difference-in-hours-minutes-and-seconds
      now_mm, now_ss = time.to_i.divmod(60)
      now_hh, now_mm = now_mm.divmod(60)
      if (now_hh < 24)
        now = "%02d:%02d:%02d" % [now_hh, now_mm, now_ss]
      else
        now_dd, now_hh = now_hh.divmod(24)
        now = "%04d days %02d:%02d:%02d" % [now_dd, now_hh, now_mm, now_ss]
      end
    rescue
      now "unknown"
    end
  end

  public

  # getter ---------------------------------------------------------------------
  def getSongs(bot, search, where = "", count = -1)
    songs = []
    if search != ""
      i = 0
      if where == "file"
        bot[:mpd].where(file: "#{search}").each do |song|
          songs.push(song); i = i + 1; break if i == count
        end
      elsif where == "title"
        bot[:mpd].where(title: "#{search}").each do |song|
          songs.push(song); i = i + 1; break if i == count
        end
      elsif where == "artist"
        bot[:mpd].where(artist: "#{search}").each do |song|
          songs.push(song); i = i + 1; break if i == count
        end
      elsif where == "album"
        bot[:mpd].where(album: "#{search}").each do |song|
          songs.push(song); i = i + 1; break if i == count
        end
      elsif where == "date"
        bot[:mpd].where(date: "#{search}").each do |song|
          songs.push(song); i = i + 1; break if i == count
        end
      else
        bot[:mpd].where(any: "#{search}").each do |song|
          songs.push(song); i = i + 1; break if i == count
        end
      end
    end
    return songs
  end

  def getFirstSong(bot, search, where = "")
    song = nil
    if search != ""
      song = bot[:mpd].where(file: "#{search}").first if where == "file"
      song = bot[:mpd].where(title: "#{search}").first if where == "title"
      song = bot[:mpd].where(artist: "#{search}").first if where == "artist"
      song = bot[:mpd].where(album: "#{search}").first if where == "album"
      song = bot[:mpd].where(date: "#{search}").first if where == "date"
      song = bot[:mpd].where(any: "#{search}").first if where == ""
    end
    return song
  end

  def getLastSong(bot, search, where = "")
    song = nil
    if search != ""
      song = bot[:mpd].where(file: "#{search}").last if where == "file"
      song = bot[:mpd].where(title: "#{search}").last if where == "title"
      song = bot[:mpd].where(artist: "#{search}").last if where == "artist"
      song = bot[:mpd].where(album: "#{search}").last if where == "album"
      song = bot[:mpd].where(date: "#{search}").last if where == "date"
      song = bot[:mpd].where(any: "#{search}").last if where == ""
    end
    return song
  end

  def update(bot)
    bot[:mpd].update
    while bot[:mpd].status[:updating_db]
      sleep 0.5
    end
  end

  def play(bot)
    if bot[:mpd].queue.length == 0
      privatemessage(I18n.t("plugin_mpd.play.empty"))
    else
      bot[:mpd].play
      bot[:cli].me.deafen false if bot[:cli].me.deafened?
      bot[:cli].me.mute false if bot[:cli].me.muted?
    end
  end

  def playFirst(bot)
    begin
      bot[:mpd].play 0
      privatemessage(I18n.t("plugin_mpd.play.first"))
    rescue
      privatemessage(I18n.t("plugin_mpd.play.empty"))
    end
  end

  def playLast(bot)
    if bot[:mpd].queue.length > 0
      lastsongid = bot[:mpd].queue.length.to_i - 1
      bot[:mpd].play (lastsongid)
      privatemessage(I18n.t("plugin_mpd.play.last", :id => lastsongid))
    else
      privatemessage(I18n.t("plugin_mpd.play.empty"))
    end
  end

  # search through all tags
  def addSongs(bot, search, where = "")
    if search == ""
      text_out = I18n.t("plugin_mpd.add.empty")
    else
      songs = []
      songs = getSongs(bot, search, where)
      if songs.nil?
        text_out = I18n.t("plugin_mpd.add.nothing")
      else
        for song in songs
          text_out << "add #{song.file}<br/>"
          bot[:mpd].add(song)
        end
      end
    end
    privatemessage(text_out)
  end

  # add to queue and play directly
  def addPlay(bot, search, where = "", count = 1)
    if search == ""
      text_out = I18n.t("plugin_mpd.add.empty")
    else
      songs = []
      songs = getSongs(bot, search, where, 1)
      if songs.nil?
        text_out = I18n.t("plugin_mpd.add.nothing")
      else
        for song in songs
          text_out << "add #{song.file}<br/>"
          bot[:mpd].add(song)
        end
      end
    end
    privatemessage(text_out)
  end

  # print output to user--------------------------------------------------------
  # later goes back into plugin mpd if the plugins are merged

  def printFiles(bot, search)
    if search != ""
      text_out = "#{I18n.t("plugin_mpd.where.found")}<br/>"
      bot[:mpd].where(any: "#{search}").each do |song|
        text_out << "#{song.file}<br/>"
      end
    end
    privatemessage(text_out)
  end

  def printMpdConfig(bot)
    begin
      config = bot[:mpd].config
    rescue
      config = I18n.t("plugin_mpd.mpdconfig")
    end
    privatemessage(config)
  end

  def printMpdDecoders(bot)
    output = "<table>"
    bot[:mpd].decoders.each do |decoder|
      output << "<tr>"
      output << "<td>#{decoder[:plugin]}</td>"
      output << "<td>"
      begin
        decoder[:suffix].each do |suffix|
          output << "#{suffix} "
        end
        output << "</td>"
      rescue
        output << "#{decoder[:suffix]}"
      end
    end
    output << "</table>"
    privatemessage(output)
  end

  def printPlaylists(bot)
    text_out = ""
    counter = 0
    bot[:mpd].playlists.each do |pl|
      text_out = text_out + "#{counter} - #{pl.name}<br/>"
      counter += 1
    end
    privatemessage(I18n.t("plugin_mpd.playlists", :list => text_out))
  end

  def printQueue(bot)
    if bot[:mpd].queue.length > 0
      text_out = "<table><th><td>#</td><td>Name</td></th>"
      songnr = 0
      playing = -1
      playing = bot[:mpd].current_song.pos if !bot[:mpd].current_song.nil?
      bot[:mpd].queue.each do |song|
        text_out << "<tr><td>#{songnr}</td><td>"
        songnr == playing ? text_out << "<b>" : nil
        song.title.to_s == "" ?
          (text_out << "#{song.file}") : (text_out << "#{song.title}")
        songnr == playing ? text_out << "</b>" : nil
        songnr += 1
      end
      text_out << "</table>"
    else
      text_out = I18n.t("plugin_mpd.queue.empty")
    end
    privatemessage(text_out)
  end

  def printSonglist(bot)
    block = 0
    out = ""
    bot[:mpd].songs.each do |song|
      if block >= 50
        privatemessage(out.to_s)
        out = ""
        block = 0
      end
      out << "<br/>" + song.file.to_s
      block += 1
    end
    privatemessage(out.to_s)
  end

  def printStatus(bot)
    out = "<table>"
    bot[:mpd].status.each do |key, value|
      case
      when key.to_s == "volume"
        out << "<tr><td>#{I18n.t("plugin_mpd.status.volume")}</td><td>#{value}%</td></tr>"
      when key.to_s == "repeat"
        if value
          repeat = I18n.t("plugin_mpd.status._on")
        else
          repeat = I18n.t("plugin_mpd.status._off")
        end
        out << "<tr><td>#{I18n.t("plugin_mpd.status.repeat")}</td><td>#{repeat}</td></tr>"
      when key.to_s == "random"
        if value
          random = I18n.t("plugin_mpd.status._on")
        else
          random = I18n.t("plugin_mpd.status._off")
        end
        out << "<tr><td>#{I18n.t("plugin_mpd.status.random")}</td><td>#{random}</td></tr>"
      when key.to_s == "single"
        if value
          single = I18n.t("plugin_mpd.status._on")
        else
          single = I18n.t("plugin_mpd.status._off")
        end
        out << "<tr><td>#{I18n.t("plugin_mpd.status.single")}</td><td>#{single}</td></tr>"
      when key.to_s == "consume"
        if value
          consume = I18n.t("plugin_mpd.status._on")
        else
          consume = I18n.t("plugin_mpd.status._off")
        end
        out << "<tr><td>#{I18n.t("plugin_mpd.status.consume")}</td><td>#{consume}</td></tr>"
      when key.to_s == "playlist"
        out << "<tr><td>#{I18n.t("plugin_mpd.status.playlist")}</td><td>#{value}</td></tr>"

        #FIXME Not possible, because the "value" in this context is random(?) after every playlist loading.
        #playlist = bot[:mpd].playlists[value.to_i]
        #if not playlist.nil?
        #  out << "<tr><td>Current playlist:</td><td>#{playlist.name}</td></tr>"
        #else
        #  out << "<tr><td>Current playlist:</td><td>#{value}</td></tr>"
        #end
      when key.to_s == "playlistlength"
        out << "<tr><td>#{I18n.t("plugin_mpd.status.playlistlength")}</td><td valign='bottom'>#{timedecode(value)}</td></tr>"
      when key.to_s == "mixrampdb"
        out << "<tr><td>#{I18n.t("plugin_mpd.status.mixrampdb")}</td><td>#{value}</td></tr>"
      when key.to_s == "state"
        case
        when value.to_s == "play"
          state = I18n.t("plugin_mpd.status.play")
        when value.to_s == "stop"
          state = I18n.t("plugin_mpd.status.stop")
        when value.to_s == "pause"
          state = I18n.t("plugin_mpd.status.pause")
        else
          state = I18n.t("plugin_mpd.status.unknown")
        end
        out << "<tr><td>Current state:</td><td>#{state}</td></tr>"
      when key.to_s == "song"
        current = bot[:mpd].current_song
        if current
          out << "<tr><td>#{I18n.t("plugin_mpd.status.song")}</td><td>#{current.artist} - #{current.title} (#{current.album})</td></tr>"
        else
          out << "<tr><td>#{I18n.t("plugin_mpd.status.mixrampdb")}</td><td>#{value})</td></tr>"
        end
      when key.to_s == "songid"
        #queue = Queue.new
        ##queue = bot[:mpd].queue
        #puts "queue: " + queue.inspect
        #current_song = queue.song_with_id(value.to_i)

        #out << "<tr><td>Current songid:</td><td>#{current_song}</td></tr>"
        out << "<tr><td>#{I18n.t("plugin_mpd.status.songid")}</td><td>#{value}</td></tr>"
      when key.to_s == "time"
        out << "<tr><td>#{I18n.t("plugin_mpd.status.time")}</td><td>#{timedecode(value[0])}/#{timedecode(value[1])}</td></tr>"
      when key.to_s == "elapsed"
        out << "<tr><td>#{I18n.t("plugin_mpd.status.elapsed")}</td><td>#{timedecode(value)}</td></tr>"
      when key.to_s == "bitrate"
        out << "<tr><td>#{I18n.t("plugin_mpd.status.bitrate")}</td><td>#{value}</td></tr>"
      when key.to_s == "audio"
        out << "<tr><td>#{I18n.t("plugin_mpd.status.audio")}</td><td>samplerate(#{value[0]}), bitrate(#{value[1]}), channels(#{value[2]})</td></tr>"
      when key.to_s == "nextsong"
        out << "<tr><td>#{I18n.t("plugin_mpd.status.nextsong")}</td><td valign='bottom'>#{value}</td></tr>"
      when key.to_s == "nextsongid"
        out << "<tr><td>#{I18n.t("plugin_mpd.status.nextsongid")}</td><td valign='bottom'>#{value}</td></tr>"
      else
        out << "<tr><td>#{key}:</td><td>#{value}</td></tr>"
      end
    end
    out << "</table>"
    privatemessage(out)
  end
end
