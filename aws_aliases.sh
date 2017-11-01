function ___aws-context {
  FILE="$HOME/.aws/credentials_list"
  if [ -z "$1" ]
  then
    echo "Please enter a context"
    return 0
  else
    LINE="$( cat "$FILE" | grep -n "$1")"

    if [[ -z "$LINE" ]]
    then
      echo "Context not found"
      return 0
    else
      LINE_NUMBER="$( echo "$LINE" | cut -f1 -d ":" )"

      ACCESS_KEY_LINE="$(expr "$LINE_NUMBER" + 1)"
      SECRET_LINE="$(expr "$LINE_NUMBER" + 2)"

      ACCESS_KEY="$( sed -n "${ACCESS_KEY_LINE}p" < "$FILE" )"
      SECRET="$( sed -n "${SECRET_LINE}p" < "$FILE" )"

      echo Context found, switching context...

      sed -i.bak '2 c\
      '"${ACCESS_KEY}"'
      ' "${HOME}/.aws/credentials"

      sed -i.bak '3 c\
      '"${SECRET}"'
      ' "${HOME}/.aws/credentials"
    fi
  fi
}

alias aws-context='___aws-context'
