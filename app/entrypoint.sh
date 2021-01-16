#!/usr/bin/env bash
set -euo pipefail

_wait_files() {
  for file in $@; do
    echo $file
    while true; do
      [ -e "$file" ] && break
      echo "_wait_files: waiting for $file"
      sleep 1
    done

    echo "_wait_files: found $file"
  done
}

(
  exec containerd
) 2>&1 | sed -le "s#^#containerd: #;" &

(
  _wait_files /run/containerd/containerd.sock
  exec ignited daemon --log-level trace
) 2>&1 | sed -le "s#^#ignited: #;" &

echo "hang"
tail -f /dev/null
