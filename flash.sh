#! /usr/bin/env nix-shell
#! nix-shell -i bash -p rkdeveloptool

set +x

flash="${1:-./result/image.raw}"

echo "Flashing '${flash}'"

echo "Please connect your board and boot it into maskrom mode"
while true; do
  devices=$(rkdeveloptool ld)

  if echo "${devices}" | grep -v "not found"; then
    num=$(echo "${devices}" | wc -l)
    if [[ num -ge 2 ]]; then
      echo "Found more than one device."
      echo "Please only connect one device at a time."
      echo "Exiting."
      exit 1
    fi
    sudo rkdeveloptool db rk3588_spl_loader_v1.15.113.bin
    sudo rkdeveloptool wl 0 "${flash}"
    exit 0

  fi
  echo -n "."
  sleep 3
done
