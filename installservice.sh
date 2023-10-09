#!/bin/sh
#for Ubuntu 16-20 + raspbian
#Working Beta!

# Make sure having your running script ready and in a known path before running this script

echo "Type the name of the service"
read service
echo "Type path of to the script including script ( /path/script.sh/py )"
read path
echo "Type description of service"
read description
echo "Type the name of the user running the service"
read ruser

sudo echo "
[Unit]
Description=$description
After=network.target

[Service]
User=$ruser
Restart=on-failure
RestartSec=10
ExecStart=/bin/sh "$path"

[Install]
WantedBy=multi-user.target

[Install]
WantedBy=multi-user.target" | tee -a /etc/systemd/system/$service.service

sudo chmod 755 /etc/systemd/system/$service.service
sudo echo "please put script in script-folder"
read -p "Have you done it (y/n)?" yn
   case $yn in
    [Yy]* ) sudo systemctl daemon-reload
            echo "press ctrl c to exit script and tail -f yourlog.log to follow the log"
            sudo systemctl start $service
            sudo systemctl status $service
    ;;

    [Nn]* ) exit;;
    * ) echo 'Please answer yes or no.';;
   esac
exit
