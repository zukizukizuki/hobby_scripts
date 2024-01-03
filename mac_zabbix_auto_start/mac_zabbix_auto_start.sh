#!/bin/bash

#sudo apachectl start

brew services stop httpd
brew services start httpd

brew services stop postgresql
brew services start postgresql

brew services stop php
brew services start php

sudo sysctl -w kern.sysv.shmall=2097152
sudo sysctl -w kern.sysv.shmmax=134217728
zabbix_server
zabbix_agentd
