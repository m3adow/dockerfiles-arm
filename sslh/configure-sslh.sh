#!/bin/sh
set -e
set -u
set -o pipefail
set -x

SSLH_TYPE=${SSLH_TYPE:-sslh-fork}
SSLH_PORT=${SSLH_PORT:-443}
IPSTRING=${IPSTRING:-}
DISABLE_AUTO_MODE=${DISABLE_AUTO_MODE:-}
DISABLE_IPV4=${DISABLE_IPV4:-}
ENABLE_IPV6=${ENABLE_IPV6:-}

if [ -z "${DISABLE_AUTO_MODE}" ]
then
  if [ -z "${IPSTRING}" ]
  then
    if [ -z "${DISABLE_IPV4}" ]
    then
      for MYIP in $(ip a | grep "inet "| awk '{print $2}')
      do
        IPSTRING="${IPSTRING} --listen ${MYIP%%/*}:${SSLH_PORT}"
      done
    fi
    if [ -n "${ENABLE_IPV6}" ]
    then
      for MYIP in $(ip a | grep "inet6 "| awk '{print $2}')
      do
        IPSTRING="${IPSTRING} --listen ${MYIP%%/*}:${SSLH_PORT}"
      done
    fi
  fi
fi

exec /usr/local/bin/${SSLH_TYPE} -f ${IPSTRING} $@
