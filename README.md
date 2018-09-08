# Mumble-Ruby-PluginBot-Plugins
A plugin collection for the [mumble-ruby-pluginbot](https://github.com/Shadowsith/mumble-ruby-pluginbot)

<div align="center">
   <img src="./logo/mumble-ruby-pluginbot.png" width="300px" heigth="300px">
</div>

Only use the plugins at your own risk.<br>
It is highly recommended to only use plugins which are in the stable branch.

## Motivaton/Target

Target of this project is to merge the plugins later directly to the orginal pluginbot and
make it better comparable to the Teamspeak/Discord bot "Sinusbot"

## Plugins
A short plugin overview:

### System (finished)
Information about the linux system where the pluginbot is running

### Search
Demo plugin to search files in music folder of the bot<br>

### SearchPlay
Are you lazy to use .add and .play each time for playing an audio file?

The new commands <code>splay [file] | spl [file]</code> automatically add and play files if the search finds a file

#### Installation
Move:
* plugins/splay.rb to mumble-ruby-pluginbot/plugins

### Metadata
This plugin allows to:
* Show metadata from single file
* List files with same search pattern in all meta tags
* Set meta tags for mp3 files

#### Requirements
Debian/Ubuntu:<br>
<code>sudo apt-get install id3v2</code>

Arch Linux:<br>
<code>sudo pacman -S id3v2</code>

CentOS/Scientific Linux/Fedora/RHEL:<br>
<code>sudo yum install id3v2</code>

#### Installation
Move:
* helpers/id3v2.rb to mumble-ruby-pluginbot/helpers
* plugins/metadata.rb to mumble-ruby-pluginbot/plugins

#### Troubleshooting:
If you want to editing

### PicoTTS
Local text to speech functionality for the bot which includes 6 languages.

* British English
* US English
* German
* Spanish
* French
* Italian

#### Requirements
Debian/Ubuntu based systems:<br>
<code>sudo apt-get install libttspico-utils</code>

Arch Linux:<br>
Install <code>svox-pico-bin</code> form Arch AUR

CentOS/Scientific Linux/Fedora/RHEL:<br>
<code>wget https://raw.githubusercontent.com/stevenmirabito/asterisk-picotts/master/picotts-install.sh -O - | sh</code>

#### Installation
Move:
* helpers/ttsh.rb to mumble-ruby-pluginbot/helpers
* helpers/picottsh.rb to mumble-ruby-pluginbot/helpers
* plugins/picotts.rb to mumble-ruby-pluginbot/plugins
* plugins/picotts.yml to mumble-ruby-pluginbot/plugins

### GoogleTTS
Text to speech functionality with help of google text to speech engine<br>

#### Requirements
mplayer

#### Installation
Move:
* helpers/ttsh.rb to mumble-ruby-pluginbot/helpers
* helpers/googlettsh.rb to mumble-ruby-pluginbot/helpers
* plugins/googletts.rb to mumble-ruby-pluginbot/helpers
* plugins/googletts.yml to mumble-ruby-pluginbot/helpers

#### Limitations
GoogleTTS allows only 200 characters

### MaryTTS
Text to speech functionality with help of open source mary text to speech engine

#### Implemented languages
* English
* German

#### Voice variants
* male
* female

#### Installation
* helpers/ttsh.rb to mumble-ruby-pluginbot/helpers
* helpers/maryttsh.rb to mumble-ruby-pluginbot/helpers
* plugins/marytts.rb to mumble-ruby-pluginbot/helpers
* plugins/marytts.yml to mumble-ruby-pluginbot/helpers

#### Limitations
The MaryTTS plugins has a limitation to max 200 characters (max allowed chars in HTTP-Request) but it is planned to
raise this up to 1000 characters

### Remove (in development)
Deletes music files from file system<br>

### Move (Coming soon)
Move/rename music files from one folder into onther<br>
