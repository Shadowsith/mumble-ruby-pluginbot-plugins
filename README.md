# Mumble-Ruby-PluginBot-Plugins (Stable branch)
A plugin collection for the [mumble-ruby-pluginbot](https://github.com/Shadowsith/mumble-ruby-pluginbot)

Only use the plugins at your own risk.

## Installation
Firstly make sure that the pluginbot is [installed](http://mumble-ruby-pluginbot.readthedocs.io/en/master/installation_howto.html) correctly: 

Put the files in the plugin directory into the plugin directory<br>
If helper classes are required move also the files form helpers to helpers in pluginbot

## Stable Plugins
A short plugin overview:

### System
Information about the linux system where the pluginbot is running

### Search
Demo plugin to search files in music folder of the bot<br>
**Third party requirements**: find <br>

### SearchPlay
Are you lazy to use .add and .play each time for playing an audio file?

The new commands <code>splay [file] | spl [file]</code> automatically add and play files if the search finds a file

### MaryTTS
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
