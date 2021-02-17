#!/bin/bash

# exec bundle exec thin start -R config.ru -p 9292
exec bundle exec puma config.ru -p 2600
