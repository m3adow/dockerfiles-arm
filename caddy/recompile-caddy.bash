#!/bin/bash
set -x
set -e
set -u
set -o pipefail

PLUGINFILE="${PLUGINFILE:-"/etc/caddyplugins.conf"}"
SED_ADDLINE="${SED_ADDLINE:-// This is where other plugins get plugged in (imported)}"
CADDY_SRCDIR="${CADDY_SRCDIR:-"${GOPATH}/src/github.com/mholt/caddy"}"
CADDY_RUNFILE="${CADDY_RUNFILE:-"${CADDY_SRCDIR}/caddy/caddymain/run.go"}"
CADDY_REBUILDSCRIPT="${CADDY_REBUILDSCRIPT:-"${CADDY_SRCDIR}/caddy/build.bash"}"

recompile(){

  for PLUGIN in $(echo "${1}"| tr ',' ' ')
  do
    # Iterate through PLUGINFILE, add to caddymain/run.go
    # If PLUGIN is in the tags, it's succeeded by a blank
    PLUGIN_IMPORT="$(grep -E "${PLUGIN} " ${PLUGINFILE} | awk '{print $NF}')"
    if [[ "$(echo "${PLUGIN_IMPORT}" | wc -l)" -eq 1 ]]
    then
      if [[ "$(grep -E "_ \"${PLUGIN_IMPORT}\"" ${CADDY_RUNFILE})" ]]
      then
        # Naively assume everything's good and continue with next PLUGIN
        continue
      fi

      sed -i "s|\(${SED_ADDLINE}\)|\1\n\t_ \"${PLUGIN_IMPORT}\"|" ${CADDY_RUNFILE}
      # Some plugins need a "go generate" for a successful compile
      go get ${PLUGIN_IMPORT} || {
        go generate ${PLUGIN_IMPORT}
        go get ${PLUGIN_IMPORT}
      }

    else
      echo "Expected one result for '${PLUGIN_IMPORT}', got '$(echo "PLUGIN_IMPORT" | wc -l)' instead."
      exit 1
    fi
  done

  #${CADDY_REBUILDSCRIPT}
  go install github.com/mholt/caddy/caddy

}

if [[ -d "/usr/local/go/bin" ]]
then
  export PATH=/usr/local/go/bin:${PATH}
fi

if [[ "${CADDY_PLUGINS:-}" ]]
then
  recompile "${CADDY_PLUGINS}"
elif [[ "$(echo "${1:-}"| grep -E '^recompile=')" ]]
  then
    recompile "${1#*=}"
fi

if [[ "${DONT_EXEC:-}" ]]
then
  exit 0
fi

exec  /go/bin/caddy "$@"
