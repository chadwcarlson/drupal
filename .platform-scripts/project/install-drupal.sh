#!/usr/bin/env bash
########################################################################################################################
# NOTE:
# 
# This script installs Drupal, depending on the demo settings set in the PLATFORMSH_DEMO environment variable.
#
# An initial admin user is created, using the Platform.sh-provided environment variable PLATFORM_PROJECT_ENTROPY for the
#   initial password. 
#
# It is run on all demo cases, except for `starter`, where no installation occurs.
#
########################################################################################################################
if [[ "$PLATFORMSH_DEMO" != "starter" ]]; then

    # Customize the installation based on the demo "type".
    if [[ "$PLATFORMSH_DEMO" == "standard" ]] || [[ "$PLATFORMSH_DEMO" == "standard-demo" ]]; then
        INSTALL_PROFILE=standard
        SITE_NAME="Drupal on Platform.sh"
    fi
    if [[ "$PLATFORMSH_DEMO" == "standard-gatsby" ]] || [[ "$PLATFORMSH_DEMO" == "gatsby-demo" ]]; then
        INSTALL_PROFILE=standard
        SITE_NAME="Decoupled Drupal (Gatsby) on Platform.sh"
    fi
    if [[ "$PLATFORMSH_DEMO" == "standard-nextjs" ]] || [[ "$PLATFORMSH_DEMO" == "nextjs-demo" ]]; then
        INSTALL_PROFILE=standard
        SITE_NAME="Decoupled Drupal (Next.js) on Platform.sh"
    fi
    if [[ "$PLATFORMSH_DEMO" == "umami-demo" ]]; then
        INSTALL_PROFILE=demo_umami
        SITE_NAME="Umami"
    fi

    printf "    ✔ Initializing demo: $PLATFORMSH_DEMO\n"
    printf "    ✔ Installing Drupal with profile: $INSTALL_PROFILE\n"

    # 1. Define initial admin password. 
    INIT_ADMIN_PASS=${PLATFORM_PROJECT_ENTROPY}

    # 2. Install the site.
    drush si $INSTALL_PROFILE -q --site-name=$SITE_NAME --account-pass=$INIT_ADMIN_PASS -y

    # 3. Warn the user about the initial admin account.
    printf "    ✔ Installation complete.\n"
    printf "    ✔ Your Drupal site has been installed with the following credentials:\n"
    printf "        * \033[1muser:\033[0m admin\n"
    printf "        * \033[1mpass:\033[0m $INIT_ADMIN_PASS\n"
    printf "    ✗ \033[1mWARNING: Update your password and email immediately.\033[0m\n"

    # 4. Rebuild the cache.
    drush cr -y -q

fi
