#! /bin/bash

SCRIPT_PATH="/usr/local/bin"
SCRIPT_TARGET="$SCRIPT_PATH/rpi-auto-hostname.sh"

if [ "$EUID" -ne 0 ]
  then echo "Please run as root."
  exit
fi

if [ ! -f "$SCRIPT_TARGET" ]; then
  echo "Adding hostname-script '${SCRIPT_TARGET}'."
  cat > "$SCRIPT_TARGET" <<END
#! /bin/bash

# load configuration
. /etc/rpi-auto-hostname.conf

# generate hostname
HOSTNAME="\${PREFIX}-\$(/bin/cat /proc/cpuinfo | /bin/grep ^Serial | /bin/sed -n 's/^.*: 0*//p')"

# set hostname
/bin/hostname "\$HOSTNAME"
/bin/echo "\$HOSTNAME" > /etc/hostname
END
    test -x "$SCRIPT_TARGET" || chmod +x "$SCRIPT_TARGET"
fi

if [ ! -f "/etc/rpi-auto-hostname.conf" ]; then
    echo "Adding default configuration to '/etc/rpi-auto-hostname.conf'."
    echo "PREFIX='rpi'" > "/etc/rpi-auto-hostname.conf"
fi

if [ ! -f "/etc/systemd/system/rpi-auto-hostname.service" ]; then
  echo "Adding systemctl config to '/etc/systemd/system/rpi-auto-hostname.service'."
  cat > /etc/systemd/system/rpi-auto-hostname.service <<END
[Unit]
Description=Set hostname based on RPI ID

Before=network-pre.target
Wants=network-pre.target

DefaultDependencies=no
Requires=local-fs.target
After=local-fs.target

[Service]
Type=oneshot

ExecStart=$SCRIPT_TARGET

RemainAfterExit=no

[Install]
WantedBy=network.target
END

/bin/systemctl enable rpi-auto-hostname
/bin/systemctl daemon-reload
fi

