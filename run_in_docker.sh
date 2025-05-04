#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function dockerize_cli_init () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  cd -- "$SELFPATH" || return $?
  local RUNMODE="${1:-serve}"; shift

  local DK_IMAGE='node:22'
  local DK_BASE=(
    docker run
    --rm --restart=no
    --tty
    --hostname mcbot
    --volume="$PWD:/app:rw"
    )

  local KEY= VAL="cfg.@$HOSTNAME.rc"
  [ ! -f "$VAL" ] || source -- "$VAL" || return $?
  for KEY in $(env | grep -oPe '^mcr_\w+(?==)') ; do
    DK_BASE+=( --env="$KEY" )
  done
  [ -d "$HOME"/.node_modules ] && DK_BASE+=(
    --volume="$HOME/.node_modules/:/$HOME/.node_modules:rw" )

  local DK_CMD=()
  case "$RUNMODE" in
    serve ) DK_CMD=( node /app/bot.mjs );;
    /*/ )
      DK_BASE+=( --interactive --workdir "$RUNMODE" )
      DK_CMD=( "$@" )
      [ "$#" -ge 1 ] || DK_CMD=( bash -i )
      ;;
    * ) echo E: "Unsupported runmode: $RUNMODE" >&2; return 4;;
  esac

  exec "${DK_BASE[@]}" "$DK_IMAGE" "${DK_CMD[@]}"
}










dockerize_cli_init "$@"; exit $?
