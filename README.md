# rpi-auto-hostname
Automatic set unique hostname on boot

## How it works
On each boot a script the script updates `/etc/hostname` and runs `hostname` to
set it to `{prefix}-{raspberryid}`.'

## Installation
```
curl https://raw.githubusercontent.com/the-louie/rpi-auto-hostname/master/install.sh | sudo bash
```
Or download `install.sh` and run it after you inspected it.

## Configuration
You can change the prefix in `/etc/rpi-auto-hostname.conf`. Default prefix is `rpi`.

## Feature requests
I welcome feature requests, please just make sure you attach them to a pull-request.
