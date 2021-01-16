function checkGlobalContext {
  if [ -z "$1" ]
  then
    return 0;
  else
    KUBE_CONTEXT="$( echo "$(kube-which)" | cut -d':' -f 2 | sed 's/ //g')"
    AWS_CONTEXT="$( echo "$(aws-which)" | cut -d':' -f 2 | sed 's/ //g')"

    if [ "$1" != "$KUBE_CONTEXT" ]
    then
      echo [Warning]: Kube context does not match kops context, please run this command again with --all to fix.
      echo Current Kube context: "$KUBE_CONTEXT"
    fi

    if [ "$1" != "$AWS_CONTEXT" ]
    then
      echo [Warning]: AWS context does not match kops context, please run this command again with --all to fix.
      echo Current AWS context: "$AWS_CONTEXT"
    fi
  fi
}

function doCommand {
  KOPS_HELPER_PATH="${HOME}/kopshelper/kube-setup/manage-cluster"

  if [ -f "$KOPS_HELPER_PATH"/"$1" ]
  then
    sh "$KOPS_HELPER_PATH"/"$1"
    return 0;
  else
    if [ -f "$KOPS_HELPER_PATH"/"$2"/"$1" ]
    then
      sh "$KOPS_HELPER_PATH"/"$2"/"$1"

      return 0
    else
     echo Command not found.
     return 0
    fi
  fi
}


function ___kops-manage {
  if [ -z "$1" ]
  then
    echo "Please enter a command."
  else
    if [ "$1" = "context" ]
    then
      CONFIGS_DIRECTORY="${HOME}/kopshelper/kube-setup/setup-vars-archive"
      CONFIG_FILE="${HOME}/kopshelper/kube-setup/setup-vars"

      if [ -z "$2" ]
      then
        for CURRENT_FILE in $CONFIGS_DIRECTORY/*
        do
          DIFF="$(diff "$CONFIG_FILE" "$CURRENT_FILE" )"

          if [ -z "$DIFF" ]
          then
            FILE_NAME="$( basename $CURRENT_FILE )"
            echo Current context: "$FILE_NAME"

            checkGlobalContext "$FILE_NAME"
          fi
        done
      else
        CONTEXT=""$CONFIGS_DIRECTORY"/"$2""

        if [ -f "$CONTEXT" ]
        then
          echo Context found, switching context...

          rm "$CONFIG_FILE"

          cat "$CONTEXT" >> "$CONFIG_FILE"

          echo Current context: "$2"

          if [ "$3" = "--all" ]
          then
            KUBE="$( kube-context "$2" )"
            AWS="$( aws-context "$2" )"

            if [ "$KUBE" = "Context not found" ]
            then
              echo "[Error]: Kube context not found."

              return 0
            fi

            if [ "$AWS" = "Context not found" ]
            then
              echo "[Error]: AWS context not found"

              return 0
            fi

            echo "AWS & Kube contexts found and switched, ready to proceed."
          else
            checkGlobalContext "$2"
          fi
        else
          echo Context not found
          return 0
        fi
      fi
    else
      doCommand "$1" "$2"
    fi
  fi

}

alias kops-manage='___kops-manage'