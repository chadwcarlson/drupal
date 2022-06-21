#!/usr/bin/env bash

# Setup drush. 
php ./drush/platformsh_generate_drush_yml.php

# Run the Platform.sh demo, if enabled.
.platform-scripts/demo.sh

# Drupal deployment tasks.
drush -q -y cache-rebuild
drush -q -y updatedb
drush -q -y config-import
