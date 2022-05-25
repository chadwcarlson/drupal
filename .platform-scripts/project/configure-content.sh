#!/usr/bin/env bash
########################################################################################################################
# NOTE:
# 
# This file uses a number of Drush scripts to initialize dummy content into article nodes within Drupal. It also
#   uses the pathauto module to set up path aliases for each node automatically, based on slugs from article titles. 
#
########################################################################################################################

RUN_DEMO=false

if [[ "$PLATFORMSH_DEMO" == "standard-demo" ]]; then
    RUN_DEMO=true
fi
if [[ "$PLATFORMSH_DEMO" == "gatsby-demo" ]] || [[ "$PLATFORMSH_DEMO" == "nextjs-demo" ]]; then
    RUN_DEMO=true
fi

if [[ "$RUN_DEMO" == true ]]; then 

    # 1. Setup pathauto aliases.
    printf "    ✔ Defining node aliases via pathauto.\n"
    TYPE=$(cat $ENV_SETTINGS | jq -r '.project.nodes.pathauto.type')
    BUNDLE=$(cat $ENV_SETTINGS | jq -r '.project.nodes.pathauto.bundle')
    LABEL=$(cat $ENV_SETTINGS | jq -r '.project.nodes.pathauto.label')
    PATTERN=$(cat $ENV_SETTINGS | jq -r '.project.nodes.pathauto.pattern')
    printf "        * type: $TYPE\n"
    printf "        * bundle: $BUNDLE\n"
    printf "        * label: $LABEL\n"
    printf "        * pattern: $PATTERN\n"
    drush scr $DRUPAL_SETUP/project/config-pathauto.php "$TYPE" "$BUNDLE" "$LABEL" "$PATTERN"

    # 2. Create some dummy content.
    printf "    ✔ Generating demo article nodes.\n"
    NUM_NODES=$(cat $ENV_SETTINGS | jq -r '.project.nodes.demo.num_nodes')
    NODE_DATA=$(cat $ENV_SETTINGS | jq -r '.project.nodes.demo.data')
    printf "        * data: $NODE_DATA\n"
    printf "        * num_nodes: $NUM_NODES\n"
    printf "        ! Get some coffee, this will take a moment...\n"
    drush scr $DRUPAL_SETUP/project/create-nodes.php "$NODE_DATA" $NUM_NODES

fi
