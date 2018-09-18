# Deploys all plugins to the bot at user botmaster
# later you will be ask for each plugin
cp -f ./helpers/* /home/botmaster/src/mumble-ruby-pluginbot/helpers/
cp -f ./plugins/* /home/botmaster/src/mumble-ruby-pluginbot/plugins/
cp -f ./i18n/en/* /home/botmaster/src/mumble-ruby-pluginbot/i18n/en/
cp -f ./i18n/de/* /home/botmaster/src/mumble-ruby-pluginbot/i18n/de/
sudo chown -R botmaster:botmaster /home/botmaster/src/mumble-ruby-pluginbot/
exit
