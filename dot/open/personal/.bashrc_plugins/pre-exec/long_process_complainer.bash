# long-running command complainer, using noti

preexec_functions+='save_preexec_time'
save_preexec_time() {
  export PREEXEC_CMD="$(history $HISTCMD | sed 's/ *[0-9]* *//')"
  export PREEXEC_TIME=$(date +'%s')
}

precmd_functions+='notify_about_long_running_commands'
notify_about_long_running_commands() {
  exitstatus=$?

  stop=$(date +'%s')
  start=${PREEXEC_TIME:-$stop}
  let elapsed=$stop-$start
  max=${PREEXEC_MAX:-10}

  if [ $elapsed -gt $max ]; then
    noti -t "Command ran for a while" -m "exited with status $exitstatus after $elapsed secs: ${PREEXEC_CMD:-Some command}"
  fi
  PREEXEC_TIME=
  PREEXEC_CMD=
}

