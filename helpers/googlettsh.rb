# This plugin requires mplayer

class GoogleTTSHelper
  private

  REQUEST = "http://translate.google.com/translate_tts?ie=UTF-8&total=1&idx=0i" \
  "&textlen=32&client=tw-ob&q="
  MPLAYER = "mplayer "
  MP_PARA = " -vc null -vo null -ao pcm:fast:waveheader:file="
  FFMPEG = "ffmpeg -loglevel quiet -y -i "
  FF_PARA = "-vn -ar 44100 -ac 2 -ab 192k -f mp3 -metadata title=\"google\" " \
  "-metadata artist=\"google\" "
  FILE = "google.wav "
  OUTPUT_FILE = "google.mp3"
  RM = "rm "
  QUIET = " > /dev/null 2>&1"

  public

  def initialize(path, message, lang)
    @mpath = path
    @lang = "&tl=" + lang
    @message = "\"" + REQUEST + message + @lang + "\""
    @download = MPLAYER + @message + MP_PARA + @mpath + FILE + QUIET
    @audio = FFMPEG + @mpath + FILE + FF_PARA + @mpath + OUTPUT_FILE
    @delete = RM + @mpath + FILE
  end

  def getFileName
    return OUTPUT_FILE
  end

  def load
    system(@download)
    system(@audio)
    system(@delete)
  end
end
