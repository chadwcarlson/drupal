#!/usr/bin/env bash
WAIT=$1
COMMIT_STATUS="pending"
sleep 5
STATUSES=$(curl -s https://api.github.com/repos/$GITHUB_REPOSITORY/statuses/$GITHUB_SHA  | jq -r 'length')
if [ $STATUSES == 0 ]; then
    echo "Not on a Platform.sh integrated environment. Skipping."
else
    echo "Waiting for Platform.sh integration status to complete."
    if [ "$WAIT" == "true" ]; then
    until [ "$COMMIT_STATUS" == "success" ] || [ "$COMMIT_STATUS" == "failure" ]; do
        sleep 5
        ENV_URL=$(curl -s https://api.github.com/repos/$GITHUB_REPOSITORY/statuses/$GITHUB_SHA  | jq -r '.[0].target_url')
        COMMIT_STATUS=$(curl -s https://api.github.com/repos/$GITHUB_REPOSITORY/statuses/$GITHUB_SHA  | jq -r '.[0].state')       
    done
    else
        ENV_URL=$(curl -s https://api.github.com/repos/$GITHUB_REPOSITORY/statuses/$GITHUB_SHA  | jq -r '.[0].target_url')
        COMMIT_STATUS=$(curl -s https://api.github.com/repos/$GITHUB_REPOSITORY/statuses/$GITHUB_SHA  | jq -r '.[0].state') 
    fi
    echo "Platform.sh deployment complete."
    echo "Status: $COMMIT_STATUS"
fi
