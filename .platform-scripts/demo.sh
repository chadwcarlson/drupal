#!/usr/bin/env bash

########################################################################################################################
# ABOUT:
# 
# This script has been included to deploy a demo Drupal application. Under normal circumstances, it will simply run 
#   common drush tasks that should be run on every deployment. In other cases, namely when the PLATFORMSH_DEMO
#   environment variable has been set, additional tasks will be executed, such as running through the Drupal installer,
#   creating a number of dummy content nodes (articles), and enabling/configuring modules. 
# 
########################################################################################################################
# NOTE:
# 
# There are a lot of moving pieces in this demo, so included is a .platform-scripts/settings.default.json file meant to
#   track it all. In this first step, the file is copied to the Network Storage mount 'deploy'. This does two things.
#   First, we can write to it at runtime, and second, if you should in the future choose to add a frontend to your 
#   project (i.e. Gatsby, Next.js) that consumes Drupal's API, that frontend will have access to those settings.
#   Initial settings committed to the demo (INITAL_DEMO_SETTINGS) are moved to the mount early in the script (ENV_SETTINGS).
#   See `.environment` for these settings files exact paths on Platform.sh environments.
#
########################################################################################################################
# STEPS:
#
#   a. Setup Drush: performed on every deployment.
#   b. Project installation: only performed during first deployment on a new project.
#   c. Environment configuration: performed during the first push on a new environment.
#
########################################################################################################################
# a. Setup Drush: performed on every deployment.
php ./drush/platformsh_generate_drush_yml.php
########################################################################################################################
# b. Project installation: only performed during first deployment on a new project.
if [ -f "$ENV_SETTINGS" ]; then
    printf "\n* Project already installed. Skipping installation.\n"
else
    printf "\n* Fresh project detected.\n"
    # 0. Track the installation in a writable file, making note of the current environment before anything else. (See NOTE).
    UPDATED_DATA=$(jq --arg PLATFORM_BRANCH "$PLATFORM_BRANCH" '.environment.branch = $PLATFORM_BRANCH' $INITIAL_DEMO_SETTINGS)
    echo $UPDATED_DATA > $ENV_SETTINGS

    # 1. Install Drupal with default profile + creds.
    $DRUPAL_SETUP/project/install-drupal.sh

    # 2. Enable modules.
    $DRUPAL_SETUP/project/enable-modules.sh

    # 3. Configure content.
    $DRUPAL_SETUP/project/configure-content.sh

    # 4. Rebuild the cache.
    printf "    ✔ Rebuilding the cache.\n"
    drush -q -y cr
fi
########################################################################################################################
# c. Environment configuration: performed during the first push on a new environment.
if [ -f "$ENV_SETTINGS" ]; then

    printf "* Configuring the environment.\n"
    # 1. Check the current environment and project status.
    PROD_INSTALL=$(cat $ENV_SETTINGS | jq -r '.project.production.installed')
    PREPPED_ENV=$(cat $ENV_SETTINGS | jq -r '.environment.branch')

    # 2. Run setup if a) very first project deploy on production environment, or b) first deploy on a new environment.
    if [ "$PROD_INSTALL" = false ]  || [ "$PREPPED_ENV" != "$PLATFORM_BRANCH" ]; then

        # a. Track the installation and configure the frontend.
        $DRUPAL_SETUP/environment/track-installation.sh

    else
        printf "* Environment already prepped for frontend. Skipping setup.\n"
    fi
else
    printf "✗ Something went wrong during the installation phase. Investigate!\033"
    exit 1
fi
########################################################################################################################
