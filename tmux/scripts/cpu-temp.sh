#!/usr/bin/env bash

command -v osx-cpu-temp >/dev/null 2>&1 || exit 0

temp=$(osx-cpu-temp 2>/dev/null | sed 's/[^0-9.]//g')
printf '%.0fC' "$temp"
