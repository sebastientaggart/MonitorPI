#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/config.env"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Missing config.env — copy config.example.env to config.env and edit it." >&2
  exit 1
fi

# shellcheck source=/dev/null
source "$CONFIG_FILE"

export DISPLAY="${DISPLAY:-:0}"
export PIR_GPIO IDLE_SECONDS POLL_SECONDS

unclutter &

python3 "${SCRIPT_DIR}/motion-sensor-screen.py" &

if [[ -f "$CHROMIUM_PREFS" ]]; then
  sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' "$CHROMIUM_PREFS"
  sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' "$CHROMIUM_PREFS"
fi

if command -v chromium >/dev/null 2>&1; then
  CHROMIUM=chromium
elif command -v chromium-browser >/dev/null 2>&1; then
  CHROMIUM=chromium-browser
else
  echo "Chromium not found. Install chromium or chromium-browser." >&2
  exit 1
fi

"$CHROMIUM" --check-for-update-interval=31536000 --kiosk "$KIOSK_URL" &

# To reload the current tab:
#  apt install xdotool
#  DISPLAY=:0 xdotool key F5

# To quit Chromium:
#  pkill -o chromium

# To change screen timeout (in seconds)
#  DISPLAY=:0 xset s 60

# Turn display on or off
#  DISPLAY=:0 xset dpms force on
#  DISPLAY=:0 xset dpms force off
