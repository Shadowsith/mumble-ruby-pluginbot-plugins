# This plugins requires mplayer 

class GoogleTTS 
    private 
        REQUEST = "http://translate.google.com/translate_tts?ie=UTF-8&total=1&idx=0&textlen=32&client=tw-ob&q="
        PARAMETER = " -vc null -vo null -ao pcm:fast:waveheader:file="
        @@lang = "&tl="
        @@mplayer = "mplayer "
        @@file = "test.wav"
        @@cmd = ""

    public
        def initialize(message, lang)
            @message = "\""+REQUEST+message+@@lang+lang+"\""
            @@cmd = @@mplayer + @message + PARAMETER + @@file;
        end

        def play
            system(@@cmd)
        end

end

