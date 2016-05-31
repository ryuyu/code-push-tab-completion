_code-push()
{
  if [ ! -e ~/.code-push-cache ] ; then
    mkdir ~/.code-push-cache
  fi

  local cur prev opts base_command
  COMPREPLY=()
  curr=${COMP_WORDS[COMP_CWORD]}
  prev=${COMP_WORDS[COMP_CWORD-1]}
  base_command=${COMP_WORDS[1]}

  if [ $prev == "--format" ] ; then
    opts="json table"
  elif [ $COMP_CWORD -eq 1 ] ; then
    opts="access-key app collaborator deployment link login logout patch promote register release release-cordova release-react rollback whoami"
  else
    case "$base_command" in
      "access-key")
        if [ $COMP_CWORD -eq 2 ] ; then
          opts="add remove list"
        fi
        ;;
      "app")
        if [ $COMP_CWORD -eq 2 ] ; then
          opts="add remove rename list transfer"
        elif [ $COMP_CWORD -eq 3 ] ; then
          if ([ "${COMP_WORDS[2]}" = "list" ] || [ "${COMP_WORDS[2]}" = "ls" ]) &&  [[ $curr == "-"* ]] ; then
            opts="--format"
          fi
        fi
        ;;
      "collaborator")
        if [ $COMP_CWORD -eq 2 ] ; then
          opts="add remove list"
        elif [ $COMP_CWORD -eq 4 ] ; then
          if ([ "${COMP_WORDS[2]}" = "list" ] || [ "${COMP_WORDS[2]}" = "ls" ]) &&  [[ $curr == "-"* ]] ; then
            opts="--format"
          fi
        fi
        ;;
      "deployment")
        if [ $COMP_CWORD -eq 2 ] ; then
          opts="add clear remove rename list history"
        elif [ $COMP_CWORD -eq 3 ] ; then
          if [ ! -e ~/.code-push-cache/applist ] || test `find ~/.code-push-cache/applist -mmin +1` ; then
            code-push app list --format json | grep name | sed s/\ \ \ \ \"name\"\:\ \"//g | sed s/\",//g > ~/.code-push-cache/applist
          fi

          opts=$(cat ~/.code-push-cache/applist)
        elif [ $COMP_CWORD -eq 4 ] ; then
          if ([ "${COMP_WORDS[2]}" = "list" ] || [ "${COMP_WORDS[2]}" = "ls" ]) && [[ $curr == "-"* ]] ; then
            opts="--displayKeys --format"
          fi
        elif [ $COMP_CWORD -gt 4 ] ; then
          if ([ "${COMP_WORDS[2]}" = "history" ] || [ "${COMP_WORDS[2]}" = "h" ]) && [[ $curr == "-"* ]] ; then
            opts="--displayAuthor --format"
          fi
        fi
        ;;
      "login")
        if [[ $curr == "-"* ]] ; then
          opts="--proxy --noproxy --accessKey"
        fi
        ;;
      "release")
        if [ $COMP_CWORD -gt 4 ] && [[ $curr == "-"* ]] ; then
          opts="--deploymentName --description --disabled --mandatory --rollout"
        fi
        ;;
      "release-react")
        if [ $COMP_CWORD -gt 3 ] && [[ $curr == "-"* ]] ; then
          opts="--bundleName --deploymentName --description --development --disabled --entryFile --mandatory --sourcemapOutput --targetBinaryVersion --rollout"
        fi
        ;;
      "release-cordova")
        if [ $COMP_CWORD -gt 3 ] && [[ $curr == "-"* ]] ; then
          opts="--deploymentName --description --mandatory --targetBinaryVersion --rollout --build"
        fi
        ;;
      "patch")
        if [ $COMP_CWORD -gt 3 ] && [[ $curr == "-"* ]] ; then
          opts="--label --mandatory --description --rollout --disabled --targetBinaryVersion"
        fi
        ;;
      "promote")
        if [ $COMP_CWORD -gt 3 ] && [[ $curr == "-"* ]] ; then
          opts="--description --disabled --mandatory --rollout --targetBinaryVersion"
        fi
        ;;
      "rollback")
        if [ $COMP_CWORD -gt 4 ] && [[ $curr == "-"* ]] ; then
          opts="--targetRelease"
        fi
        ;;
      *)
        ;;
    esac
  fi

  COMPREPLY=($(compgen -W "$opts" -- $curr))

  return 0
}

complete -F _code-push code-push
