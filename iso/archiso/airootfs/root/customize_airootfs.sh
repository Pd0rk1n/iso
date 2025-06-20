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

if command -v gsettings >/dev/null 2>&1; then
  eval $(dbus-launch)

  gsettings set org.cinnamon.desktop.default-applications.terminal exec "xfce4-terminal"
  gsettings set org.cinnamon.desktop.default-applications.terminal exec-arg "-e"

  mkdir -p /etc/skel/.config/dconf
  cp /root/.config/dconf/user /etc/skel/.config/dconf/user

  kill $DBUS_SESSION_BUS_PID
  unset DBUS_SESSION_BUS_PID
fi

## Spotify adblock patch
sed -i 's|^Exec=spotify|Exec=env LD_PRELOAD=/usr/lib/spotify-adblock.so spotify %U|' /usr/share/applications/spotify.desktop


### To Fish We Go
echo "Setting fish as default shell system-wide..."
grep -qxF '/usr/bin/fish' /etc/shells || echo '/usr/bin/fish' >> /etc/shells
chsh -s /usr/bin/fish root
sed -i 's|^SHELL=.*|SHELL=/usr/bin/fish|' /etc/default/useradd

