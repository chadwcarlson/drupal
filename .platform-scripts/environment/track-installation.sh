#!/usr/bin/env bash
########################################################################################################################
# NOTE:
# 
# This script simply updates the settings.json file kept in the Network Storage mount so that the demo Drupal
#   installation can be logged, and therefore skipped on subsequent deployments.
#
########################################################################################################################
SPLIT_LINE="-------------------------------------------------------------------------------------------------------------"

# 1. Track the overall installation. 
if [[ "$PLATFORM_ENVIRONMENT_TYPE" == "production" ]]; then
    printf "    ✔ Logging production installation\n"
    SETTINGS_UPDATES=$(jq '.project.production.installed = true' $ENV_SETTINGS)
    echo $SETTINGS_UPDATES > $ENV_SETTINGS
fi
