:
set -x
PYPI_PROXY_PORT=3141
APT_PROXY_PORT=3142
HOST_IP=$(awk '/^[a-z]+[0-9]+\t00000000/ { printf("%d.%d.%d.%d\n", "0x" substr($3, 7, 2), "0x" substr($3, 5, 2), "0x" substr($3, 3, 2), "0x" substr($3, 1, 2)) }' < /proc/net/route)
if test -z "$HOST_IP";then echo "HOST_IP not found" 1>&2; exit 1; fi
mkdir -p /home/user/.config/pip && cat > /home/user/.config/pip/pip.conf <<-EOL
[global]
index-url = http://$HOST_IP:$PYPI_PROXY_PORT/root/pypi/+simple/
[install]
trusted-host = $HOST_IP 
EOL
mkdir -p /etc/apt/apt.conf.d && cat > /etc/apt/apt.conf.d/01proxy <<-EOL
Acquire::HTTP::Proxy "http://$HOST_IP:$APT_PROXY_PORT";
Acquire::HTTPS::Proxy "false";
EOL
