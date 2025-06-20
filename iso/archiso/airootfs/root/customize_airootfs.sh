#!/usr/bin/env bash
set -e

# Install Dracula GTK theme
echo "Installing Dracula GTK theme..."
git clone https://github.com/dracula/gtk.git /tmp/dracula-gtk
mkdir -p /usr/share/themes/Dracula
cp -r /tmp/dracula-gtk/* /usr/share/themes/Dracula
rm -rf /tmp/dracula-gtk

# Set Dracula as default GTK theme for new users
echo "Setting Dracula GTK theme as default for new users..."
mkdir -p /etc/skel/.config/gtk-3.0
cat <<EOF > /etc/skel/.config/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=Dracula
EOF

echo ">>> Setting xfce4-terminal for Nemo..."

# Start a temp D-Bus session so gsettings can work
eval $(dbus-launch)

# Set terminal preference for Nemo
gsettings set org.cinnamon.desktop.default-applications.terminal exec "xfce4-terminal"
gsettings set org.cinnamon.desktop.default-applications.terminal exec-arg "-e"

# Copy Dconf settings to /etc/skel for installed user
mkdir -p /etc/skel/.config/dconf
cp /root/.config/dconf/user /etc/skel/.config/dconf/user

# Clean up D-Bus
kill $DBUS_SESSION_BUS_PID
unset DBUS_SESSION_BUS_PID

