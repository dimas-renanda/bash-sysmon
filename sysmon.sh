#!/usr/bin/env bash
# sysmon.sh — quick system snapshot

print_info() {
  echo "╔══════════════════════════════════════╗"
  echo "║         🖥  System Monitor           ║"
  echo "╠══════════════════════════════════════╣"

  # CPU
  if command -v top &>/dev/null; then
    if [[ "$OSTYPE" == darwin* ]]; then
      cpu=$(top -l 1 | awk '/CPU usage/{print $3" user, "$5" sys"}')
    else
      cpu=$(top -bn1 | awk '/Cpu/{print $2"% user, "$4"% sys"}')
    fi
    printf "║  CPU  : %-29s║\n" "$cpu"
  fi

  # Memory
  if [[ "$OSTYPE" == darwin* ]]; then
    mem=$(vm_stat | awk '
      /Pages active/   {a=$3}
      /Pages inactive/ {i=$3}
      /Pages wired/    {w=$4}
      END { printf "%.1fGB used", (a+i+w)*4096/1073741824 }')
  else
    mem=$(free -h | awk '/Mem/{print $3" / "$2}')
  fi
  printf "║  MEM  : %-29s║\n" "$mem"

  # Disk
  disk=$(df -h / | awk 'NR==2{print $3" used of "$2" ("$5")"}')
  printf "║  DISK : %-29s║\n" "$disk"

  # Uptime
  up=$(uptime | sed 's/.*up //' | sed 's/,.*//')
  printf "║  UP   : %-29s║\n" "$up"

  echo "╚══════════════════════════════════════╝"
}

if [[ "$1" == "--watch" ]]; then
  while true; do clear; print_info; sleep 2; done
else
  print_info
fi
