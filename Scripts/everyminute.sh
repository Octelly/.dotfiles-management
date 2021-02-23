/bin/date
echo Running everyminute.sh...

EUID=$(id --real --user)

PID=$(pgrep --euid $EUID gnome-session | head -n1)
#export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ|cut -d= -f2-)
export DBUS_SESSION_BUS_ADDRESS=$(cat /proc/$PID/environ | grep -z ^DBUS_SESSION_BUS_ADDRESS= | sed 's/DBUS_SESSION_BUS_ADDRESS=//')

echo $EUID
echo $PID
echo $DBUS_SESSION_BUS_ADDRESS

python3 "/home/ocean/Scripts/change wallpaper.py"
