#!/bin/sh
#
# Public Domain
#
# usage: sbb [-a] FROM TO [TIME] [DATE]
#
# API doc: <https://timetable.search.ch/api/help>

set +o nounset # FIXME: this is working around the nix thing
               # but obviously cleaner shell scripting would
               # work better.

usage() { echo "usage: sbb [-a] FROM TO [TIME] [DATE]"; exit 1; }
api_url="https://timetable.search.ch/api/route.json"

[ "$#" -ge 2 ] || usage;

# arguments
while getopts "ah" o; do case "$o" in
  (a) time_type="arrival";;
  (h) usage;;
  (*) exit 1;;
esac done && shift $((OPTIND - 1))
from="$1"
to="$2"
time="$3"
date="$4"
# a little bit of «smart»
case "$time" in
  (??h??)    time="${time%h*}:${time#*h}";;
  (?|??|??h) time="${time%h*}:00";;
esac
# The API recognizes a lot of different ways to write a date
#case "$date" in
#  ([0-9]+)               date="$(date +%Y-%m-)$date";;
#  ([0-9]+.[0-9]+)        date="$(date +%Y-)${date#*.}$-{date%.*}";;
#  ([0-9]+.[0-9]+.[0-9]+) date="${date#*.}$-{date%.*}";;
#esac

{ [ -n "$from" ] && [ -n "$to" ]; } || usage

# json path
jq_filter='
.messages[]?,
"BEGIN",
(.connections[]? |
  "BEGIN_CONNECTION",
  .departure,.from,.arr,.to,.duration,
  (.legs[] | select(has("exit")) | select(.type != "walk") |
    "LEG",
    .departure,.name,.track,
    (.exit | .arrival,.name,.track),
    .line,.terminal
  ),
  "END_CONNECTION"
),
"END"
'

# Helpers
cols=$(tput cols); [ "$cols" -lt "150" ] 2> /dev/null || cols=80
bold()      { printf '\033[1m%s\033[0m'         "$*"; }
light()     { printf '\033[2m%s\033[0m'         "$*"; }
italic()    { printf '\033[2m\033[3m%s\033[0m'  "$*"; }
red()       { printf '\033[1m\033[31m%s\033[0m' "$*"; }
underline() { printf '\033[4m%s\033[0m'         "$*"; }

# Query data, chew it, chunk it, spit it
curl -sG \
  --data-urlencode "from=$from" --data-urlencode "to=$to" \
  -d "date=$date" -d "time=$time" -d "time_type=${time_type:-depart}" \
  -d "show_delay=1" -d "show_trackchanges=1" \
  "$api_url" | jq -r "$jq_filter" | while read -r; do case "$REPLY" in

(BEGIN)
  printf '\n'
  ;;

(BEGIN_CONNECTION)
  read -r dep
  read -r from
  read -r arr
  read -r to
  read -r duration

  printf '\033[4m# From \033[1m%s\033[0m\033[4m to \033[1m%s\033[0m\033[4m on %s (%d:%02d)\033[0m\n' \
    "$from" "$to" "${dep% *}" "$((duration / 3600))" "$((duration / 60 % 60))"
  ;;

(LEG)
  read -r dep
    dep="${dep#????-??-?? }"; dep="${dep%:00}"
  read -r from
  read -r frompl
    [ -n "$frompl" ] && frompl=", track $frompl"
  case "$frompl" in (null) frompl="";; esac
  read -r arr
    arr="${arr#????-??-?? }"; arr="${arr%:00}"
  read -r to
  read -r topl
    topl="$6"; [ -n "$topl" ] && topl=", track $topl"
  case "$topl" in (null) topl="";; esac
  read -r line
  case "$number" in (??????) number="";; esac
  read -r terminal

  # FROM
  printf '%s  %s%s%*s%s\n' \
    "$dep" "$(bold "$from")" "$(light "$frompl")" \
    $(( cols - "${#dep} - "${#from} - "${#frompl} - "${#line} - 2)) "" \
    "$(bold "$line")"
  # TO
  printf '%s  %s%s%*s%s\n' \
    "$arr" "$(bold "$to")" "$(light "$topl")" \
    $(( cols - ${#arr} - ${#to} - ${#topl} - ${#terminal} - 5 )) "" \
    "$(italic "to $terminal")"
  ;;

(END_CONNECTION)
  printf '\n'
  ;;

(END)
  printf '%s\n' "$(italic "All data with no warranty whatsoever")"
  ;;

(*)
  echo "$REPLY"
  ;;

esac done | less -XFR
