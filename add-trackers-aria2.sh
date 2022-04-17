#!/usr/bin/env sh

# https://github.com/ngosang/trackerslist
URL="https://cdn.jsdelivr.net/gh/ngosang/trackerslist@master/trackers_all.txt"

CONFIG="$HOME/.config/aria2/aria2.conf"
[ -f "$CONFIG" ] || CONFIG="$HOME/.aria2/aria2.conf"

TMP="$CONFIG.tmp"

error() { echo "$@" >&2; }

if [ ! -f "$CONFIG" ] || [ ! -w "$CONFIG" ]; then
  error "Cannot access config file"
  exit 1
fi

trackers=$(curl -fsSL "$URL" | xargs | sed 's/ /,/g')

if [ -z "$trackers" ]; then
  error "$URL: Cannot retrieve trackers"
  exit 1
fi

option="bt-tracker=$trackers"
if grep -qs "^[[:space:]]*bt-tracker=" "$CONFIG"; then
  sed "s#^[[:space:]]*bt-tracker=.*\$#$option#" "$CONFIG" >"$TMP" && mv "$TMP" "$CONFIG"
else
  echo "$option" >>"$CONFIG"
fi
