#!/bin/sh

if [ -z "$HOSTNAME" ]; then
  echo "HOSTNAME must be defined"
  exit 1
fi

if [ -z "$USERNAME" ]; then
  echo "USERNAME must be defined"
  exit 1
fi

if [ -z "$PASSWORD" ]; then
  echo "PASSWORD must be defined"
  exit 1
fi

if [ -z "$INTERVAL" ]; then
  INTERVAL='30m'
fi

if [[ ! "$INTERVAL" =~ ^[0-9]+[mhd]$ ]]; then
  echo "INTERVAL must be a number followed by m, h, or d. Example: 5m"
  exit 1
fi

if [[ "${INTERVAL: -1}" == 'm' && "${INTERVAL:0:-1}" -lt 5 ]]; then
  echo "The shortest allowed INTERVAL is 5 minutes"
  exit 1
fi

USER_AGENT="cwmr/docker-google-domains-ddns"

#-----------------------------------------------------------------------------------------------------------------------

function ts {
  echo [`date '+%b %d %X'`]
}

#-----------------------------------------------------------------------------------------------------------------------

while true
do
  RESPONSE=$(curl -S -s -k --user-agent "$USER_AGENT" -u "$USERNAME:$PASSWORD" "https://domains.google.com/nic/update?hostname=$HOSTNAME" 2>&1)

  # Sometimes the API returns "nochg" without a space and ip address. It does this even if the password is incorrect.
  if [[ $RESPONSE =~ ^(good|nochg) ]]
  then
    echo "$(ts) Google Domains successfully called. Result was \"$RESPONSE\"."
  elif [[ $RESPONSE =~ ^(nohost|badauth|badagent|abuse|notfqdn) ]]
  then
    echo "$(ts) Something went wrong. Check your settings. Result was \"$RESPONSE\"."
    echo "$(ts) For an explanation of error codes, see https://support.google.com/domains/answer/6147083"
    exit 2
  elif [[ $RESPONSE =~ ^911 ]]
  then
    echo "$(ts) Server returned "911". Waiting for 30 minutes before trying again."
    sleep 1800
    continue
  else
    echo "$(ts) Couldn't update. Trying again in 5 minutes. Output from curl command was \"$RESPONSE\"."
  fi

  sleep $INTERVAL
done
