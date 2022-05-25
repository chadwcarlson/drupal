#!/usr/bin/env bash

# VARS
TEMPLATE_NAME=drupal
TEMPLATE_ORG=chadwcarlson
DEFAULT_BRANCH=main
BASE=base
TEMPLATE_UPSTREAM=git@github.com:drupal/recommended-project.git
START_VERSION=8.8.x
MAJOR_VERSION='8'
RUNTIME=php
START_RUNTIME=7.4

# SETUP THE REPO
mkdir $TEMPLATE_NAME
cd $TEMPLATE_NAME
git init
git branch -M $DEFAULT_BRANCH
gh auth login
gh repo create $TEMPLATE_ORG/$TEMPLATE_NAME --private
git remote add template git@github.com:$TEMPLATE_ORG/$TEMPLATE_NAME.git
git remote add upstream $TEMPLATE_UPSTREAM

# Initialize default branch.
echo $(date) > last_updated
git add last_updated
git commit -m "Start of template history."
git push template $DEFAULT_BRANCH

# SETUP BASE PATH.
git checkout -b $BASE-latest
git push template $BASE-latest

# Setup oldest version to start.
git checkout -b $START_VERSION-base-latest
git push template $START_VERSION-base-latest

# Setup oldest runtime to start.
git checkout -b $START_VERSION-base-$RUNTIME$START_RUNTIME
git fetch upstream
git merge upstream/$START_VERSION --allow-unrelated-histories -m "Merge remote-tracking branch 'upstream/$START_VERSION' into $START_VERSION-base-$RUNTIME$START_RUNTIME"
git push template $START_VERSION-base-$RUNTIME$START_RUNTIME

################################################################################################
# PLATFORMIFY

# Platformify the starting version path.
git checkout -b $START_VERSION-base-$RUNTIME$START_RUNTIME-platformify

# Using older PHP version on a Mac
# brew install php@7.4
# brew unlink php && brew link --overwrite --force php@7.4
# To reset to original version: brew unlink php && brew link php

# Use Composer 1
# To reset to original version: composer self-update --2
composer self-update --1

# Build the project
composer install

# Modify the project
composer config name $TEMPLATE_ORG/drupal
composer config description "Platform.sh-ready project template for Drupal $MAJOR_VERSION projects with a relocated document root"
composer config platform.php 7.4
composer config minimum-stability stable

# Add deps.
composer require platformsh/config-reader 
composer require drupal/console
composer require drupal/redis
composer require drush/drush:^10.6

# Plugin permissions.
composer config -g allow-plugins.composer/installers true --no-plugins
composer config allow-plugins.composer/installers true --no-plugins
composer config allow-plugins.drupal/core-composer-scaffold true --no-plugins
composer config allow-plugins.drupal/core-project-message true --no-plugins
composer config allow-plugins.cweagans/composer-patches true --no-plugins

# Copy over platform-specfic files. (template-builder/templates/drupal8, template-builder/common/all, template-builder/common/drupal8)
