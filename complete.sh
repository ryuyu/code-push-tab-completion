_code-push()
{
  function cacheAndGetAppList() {
    if [ ! -e ~/.code-push-cache/.applist ] || test `find ~/.code-push-cache/.applist -mmin +120` ; then
      code-push app list --format json | grep name | sed s/\ \ \ \ \"name\"\:\ \"//g | sed s/\",//g > ~/.code-push-cache/.applist
    fi

    echo $(cat ~/.code-push-cache/.applist)
  }
  
  function cacheAndGetDeploymentList() {
    local deploymentFile
    deploymentFile=~/.code-push-cache/$1
    if [ ! -e $deploymentFile ] || test `find ${deploymentFile} -mmin +120` ; then
      code-push deployment list $1 --format json | grep name | sed s/\ \ \ \ \"name\"\:\ \"//g | sed s/\",//g > $deploymentFile
    fi

    echo $(cat $deploymentFile)
  }

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
    opts="access-key app collaborator debug deployment link login logout patch promote register release release-cordova release-react rollback session whoami"
  else
    case "$base_command" in
      "access-key")
        if [ $COMP_CWORD -eq 2 ] ; then
          opts="add remove patch list"
        elif [ $COMP_CWORD -gt 2 ] ; then
          opts="--format"
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
      "debug")
        if [ $COMP_CWORD -eq 2 ] ; then
          opts="ios android"
        fi
        ;;
      "deployment")
        if [ $COMP_CWORD -eq 2 ] ; then
          opts="add clear remove rename list history"
        elif [ $COMP_CWORD -eq 3 ] ; then
          opts=$(cacheAndGetAppList)
        elif [ $COMP_CWORD -eq 4 ] ; then
          if ([ "${COMP_WORDS[2]}" = "list" ] || [ "${COMP_WORDS[2]}" = "ls" ]) && [[ $curr == "-"* ]] ; then
            opts="--displayKeys --format"
          elif [ "${COMP_WORDS[2]}" = "history" ] || [ "${COMP_WORDS[2]}" = "h" ] || [ "${COMP_WORDS[2]}" = "rename" ] ; then 
            opts=$(cacheAndGetDeploymentList ${COMP_WORDS[3]})
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
        if [ $COMP_CWORD -eq 2 ] ; then
          opts=$(cacheAndGetAppList)
        elif [ $COMP_CWORD -gt 4 ] ; then
          if [[ $curr == "-"* ]] ; then
            opts="--deploymentName --description --disabled --mandatory --rollout"
          elif [ $prev == "--deploymentName" ] || [ $prev == "-d" ] ; then
            opts=$(cacheAndGetDeploymentList ${COMP_WORDS[2]})
          fi
        fi
        ;;
      "release-react")
        if [ $COMP_CWORD -eq 2 ] ; then
          opts=$(cacheAndGetAppList)
        elif [ $COMP_CWORD -eq 3 ] ; then
          opts="android ios"
        elif [ $COMP_CWORD -gt 3 ] ; then
          if [[ $curr == "-"* ]] ; then
            opts="--bundleName --deploymentName --description --development --disabled --entryFile --mandatory --sourcemapOutput --targetBinaryVersion --rollout"
          elif [ $prev == "--deploymentName" ] || [ $prev == "-d" ] ; then
            opts=$(cacheAndGetDeploymentList ${COMP_WORDS[2]})
          fi
        fi
        ;;
      "release-cordova")
        if [ $COMP_CWORD -eq 2 ] ; then
          opts=$(cacheAndGetAppList)
        elif [ $COMP_CWORD -eq 3 ] ; then
          opts="android ios"
        elif [ $COMP_CWORD -gt 3 ] ; then
          if [[ $curr == "-"* ]] ; then
            opts="--deploymentName --description --mandatory --targetBinaryVersion --rollout --build"
          elif [ $prev == "--deploymentName" ] || [ $prev == "-d" ] ; then
            opts=$(cacheAndGetDeploymentList ${COMP_WORDS[2]})
          fi
        fi
        ;;
      "patch")
        if [ $COMP_CWORD -eq 2 ] ; then
          opts=$(cacheAndGetAppList)
        elif [ $COMP_CWORD -gt 3 ] ; then
          if [[ $curr == "-"* ]] ; then
            opts="--label --mandatory --description --rollout --disabled --targetBinaryVersion"
          elif [ $prev == "--deploymentName" ] || [ $prev == "-d" ] ; then
            opts=$(cacheAndGetDeploymentList ${COMP_WORDS[2]})
          fi
        fi
        ;;
      "promote")
        if [ $COMP_CWORD -eq 2 ] ; then
          opts=$(cacheAndGetAppList)
        elif [ $COMP_CWORD -gt 3 ] ; then
          if [[ $curr == "-"* ]] ; then
            opts="--description --disabled --mandatory --rollout --targetBinaryVersion"
          elif [ $prev == "--deploymentName" ] || [ $prev == "-d" ] ; then
            opts=$(cacheAndGetDeploymentList ${COMP_WORDS[2]})
          fi
        fi
        ;;
      "rollback")
        if [ $COMP_CWORD -eq 2 ] ; then
          opts=$(cacheAndGetAppList)
        elif [ $COMP_CWORD -gt 4 ] && [[ $curr == "-"* ]] ; then
          opts="--targetRelease"
        fi
        ;;
      "session")
        if [ $COMP_CWORD -eq 2 ] ; then
          opts="remove list"
        elif [ $COMP_CWORD -eq 3 ] ; then
          if ([ "${COMP_WORDS[2]}" = "list" ] || [ "${COMP_WORDS[2]}" = "ls" ]) &&  [[ $curr == "-"* ]] ; then
            opts="--format"
          fi
        fi
        ;;
      *)
        ;;
    esac
  fi

  if [ ! -z "$opts" ] ; then
    COMPREPLY=($(compgen -W "$opts" -- $curr))
  else
    COMPREPLY=($(compgen -f -d -- $curr))
  fi

  return 0
}

complete -F _code-push code-push
