#!bash

function showNuke {
  cat << EOF
    .................NUKEDNUKEDNUKEDNUKED.............
    ..........NUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKED.....
    .....NUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKED
    .....NUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKED
    .....NUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKED
    .....NUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKED
    .....NUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKED
    ......NUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKED....
    ..........NUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKED.....
    ......................NUKEDNUKED..................
    ......................NUKEDNUKED..................
    ......................NUKEDNUKED..................
    ......................NUKEDNUKED..................
    ......................NUKEDNUKED..................
    ......................NUKEDNUKED..................
    ......................NUKEDNUKED..................
    ......................NUKEDNUKED..................
    .................NUKEDNUKEDNUKEDNUKED.............
    .........NUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKED......
    .......NUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKED...
    NUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKEDNUKED
EOF


COUNT="$( echo -n $1 | wc -c )"

STRING="$1"

while [ $COUNT -le 49 ]
do
  (( COUNT++ ))
  if [ $(($COUNT%2)) -eq 0 ]
  then
    STRING="*$STRING"
  else
    STRING="$STRING*"
  fi
done

echo "    $STRING"

}

function ___nuke {
  if [ -z "$1" ]
  then
    echo "Please passs a directory"
    return 0
  fi

  if [[ $1 =~ ^\/ ]]
  then
    echo "No"
    return 0
  fi

  rm -rf "$1"
  showNuke "$1"
}

alias py=python3
alias nuke='___nuke'
