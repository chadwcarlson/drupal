#!/usr/bin/env bash
########################################################################################################################
# NOTE:
# 
# The demos settings file contains an array of modules that need to be enabled to make a Platform.sh Drupal demo work.
#   This script reads that array, and then enables those modules.
#
########################################################################################################################

RUN_DEMO=false

if [[ "$PLATFORMSH_DEMO" == "standard-demo" ]]; then
    RUN_DEMO=true
fi
if [[ "$PLATFORMSH_DEMO" == "standard-gatsby" ]] || [[ "$PLATFORMSH_DEMO" == "gatsby-demo" ]]; then
    RUN_DEMO=true
fi
if [[ "$PLATFORMSH_DEMO" == "standard-nextjs" ]] || [[ "$PLATFORMSH_DEMO" == "nextjs-demo" ]]; then
    RUN_DEMO=true
fi

if [[ "$RUN_DEMO" == true ]]; then
    printf "    ✔ Enabing modules.\n"

    # 1. Get the modules and print them out before enabling.
    MODULES=$(cat $ENV_SETTINGS | jq -r '.project.modules | join(" ")')
    for row in $(cat $ENV_SETTINGS | jq -r '.project.modules [] | @base64'); do
        _jq() {
            echo ${row} | base64 --decode
        }
    printf "        * $(_jq '.')\n"
    done 

    # 2. Enable them.
    drush -q pm:enable $MODULES -y
fi
