#!/bin/bash

function read_yaml
{
    filename=$1;
    declare -A yaml;
    nest=""

    while read -r line
    do
        line="$(echo -e "${line}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')" #trim string
        if [ ${#line} -ne 0 ]; then
            key=$(echo $line | cut -d':' -f 1);
            value=$(echo $line | cut -d':' -f 2);
            if [ $value ]; then
                key="$(echo -e "${key}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')" #trim string
                value="$(echo -e "${value}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')" #trim string  
                nest+="$key:$value;"
            else
                if [ $nest ]; then
                    yaml+=([$pkey]=$nest)
                    pkey="$(echo -e "${key}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')" #trim string
                    nest=""
                else
                    pkey="$(echo -e "${key}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')" #trim string
                fi
            fi
        fi
    done < $filename

    yaml+=([$pkey]=$nest)

    for key in "${!yaml[@]}"; do 
        echo "$key - ${yaml[$key]}";
    done;
}
