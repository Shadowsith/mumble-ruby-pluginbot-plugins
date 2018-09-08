# global interface for text to speech plugins

module ITextToSpeech
  def updateBot(bot)
    bot[:mpd].update
    while bot[:mpd].status[:updating_db]
      sleep 0.5
    end
  end

  def play(bot, tts)
    bot[:mpd].add(tts.getFileName)
    if bot[:mpd].queue.length > 0
      lastsongid = bot[:mpd].queue.length.to_i - 1
      bot[:mpd].play (lastsongid)
      bot[:cli].me.deafen false if bot[:cli].me.deafened?
      bot[:cli].me.mute false if bot[:cli].me.muted?
      clearQueue(bot, tts)
    end
  end

  def clearQueue(bot, tts)
    songnr = 0
    bot[:mpd].queue.each do |song|
      if bot[:mpd].queue.length - 1 <= songnr
        break
      elsif song.file == tts.getFileName
        bot[:mpd].delete songnr.to_s
        songnr -= 1
      end
      songnr += 1
    end
  end
end
