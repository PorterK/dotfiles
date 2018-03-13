#!bash

function ___kube-bash {
  if [ -z "$1" ]
  then
    echo "No namespace passed"
    return 0
  else
    local NAMESPACE="$1"

    local PODS="$(kubectl -n "$NAMESPACE" get pods -o=name)"

    local arr=($PODS)

    if [ -z "$PODS" ]
    then
      echo "Invalid namespace."
      return 0
    fi

    if [ "${#arr[@]}" -eq "1" ]
    then
      local POD="${PODS##*/}"

      kubectl -n "$NAMESPACE" exec "$POD" -it -- /bin/bash
    else
      COLUMNS=50
      select opt in "${arr[@]}" "Quit"; do
        if [ "$opt" = "Quit" ]
        then
          break
        else
          local POD="${opt##*/}"
          kubectl -n "$NAMESPACE" exec "$POD" -it -- /bin/bash
          break
        fi
      done

    fi
  fi
}

alias kube-bash='___kube-bash'

function ___kube-proxy {
  kubectl proxy
}

alias kube-proxy='___kube-proxy'

function ___kube-create-configmap {
  if [ -z "$1" ]
  then
    echo "No namespace passed"
    return 0
  else
    if [ -z "$2" ]
    then
      echo "No configmap name passed"
      return 0
    else
      if [ -z "$3" ]
      then
        echo "No filepath passed"
        return 0
      else
        local NAMESPACE="$1"
        local MAPNAME="$2"
        local FILEPATH="$3"

        kubectl delete -n "$NAMESPACE" configmap "$MAPNAME"

        kubectl create -f "$FILEPATH"

        kubectl get -n "$NAMESPACE" configmap "$MAPNAME" -o yaml
      fi
    fi
  fi
}

alias kube-create-configmap='___kube-create-configmap'

function ___kube-context {
  CONFIG_FILE="${HOME}/.kube/config"
  if [ -z "$1" ]
  then
    echo "Please enter a context"
    return 0
  else
    CHOSEN_CONTEXT="${HOME}/.kube/configs/"$1".config"
    if [[ -z "$( cat "$CHOSEN_CONTEXT" )" ]]
    then
      echo "Context not found"
      return 0
    else
      echo Context found, switching context...

      rm "$CONFIG_FILE"

      cat "$CHOSEN_CONTEXT" >> "$CONFIG_FILE"

      echo Current context: "$1"
    fi
  fi
}

alias kube-context='___kube-context'

function ___kube-create {
  if [ -z "$1" ]
  then
    echo "You must enter a file name"
    return 0
  else
    echo "File found, uploading..."

    kubectl create -f "$1"
  fi
}

alias kube-create='___kube-create'

function ___kube-replace {
  if [ -z "$1" ]
  then
    echo "You must enter a file name"
    return 0
  else
    echo "Replacing "$1"..."

    kubectl replace -f "$1" --force
  fi
}

alias kube-create='___kube-create'

alias kube='kubectl'
