# Mumble-Ruby-PluginBot-Plugins
A plugin collection for the [mumble-ruby-pluginbot](https://github.com/Shadowsith/mumble-ruby-pluginbot)

Only use the plugins at your own risk.<br>
It is highly recommended to only use plugins which are in the stable branch.

## Installation
Firstly make sure that the pluginbot is [installed](http://mumble-ruby-pluginbot.readthedocs.io/en/master/installation_howto.html) correctly: 

Put the files in the plugin directory into the plugin directory<br>
If helper classes are required move also the files form helpers to helpers in pluginbot

## Plugins
A short plugin overview:

### System (finished)
Information about the linux system where the pluginbot is running

### Search
Demo plugin to search files in music folder of the bot<br>
**Third party requirements**: find <br>

### SearchPlay (finished)
Are you lazy to use .add and .play each time for playing an audio file?

The new commands <code>splay [file] | spl [file]</code> automatically add and play files if the search finds a file

### GoogleTTS
Text to speech functionality with help of google text to speech engine<br>
**Third party requirements**: mplayer

### MaryTTS (operational)
Text to speech functionality with help of open source marry text to speech engine<br>

#### Implemanted Languages
* English
* German

#### Voice variants
* male
* female

#### Limitations
The MaryTTS plugins has a limitation to max 200 characters (max allowed chars in HTTP-Request) but it is planned to
raise this up to 1000 characters

### Remove (in development)
Deletes music files from file system<br>
**Third party requirements**: rm

**TODO**: Testing, user permissions

### Move (Coming soon)
Move/rename music files from one folder into onther<br>
**Third party requirements**: mv

### Metadata  (Coming soon)
Add/Change/View metadata to existing audiofiles<br>
**Third party requirements**: ffmpeg
