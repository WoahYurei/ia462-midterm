#!/bin/bash
set -e

docker run --rm \
  --name ia462-hardened \
  --read-only \
  --tmpfs /tmp:rw,noexec,nosuid,size=16m \
  --cap-drop ALL \
  --security-opt no-new-privileges:true \
  --security-opt seccomp="$(dirname "$(realpath "$0")")/seccomp-profile.json" \
  -p 127.0.0.1:5000:5000 \
  ia462-midterm:section3
