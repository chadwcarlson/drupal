# https://platform.sh/blog/2021/share-your-activities-with-robots-surfacing-activities-with-github-actions/

GITHUB_REPOSITORY=chadwcarlson/drupal

curl -s --location --request POST --header "Authorization: Bearer $GITHUB_TOKEN" \
    --header 'Content-Type: application/json' \
    --data-raw '{"state": "failure", "context": "platformsh", "description": "Platform.sh: Deploy hook failed."}' \
    https://api.github.com/repos/$GITHUB_REPOSITORY/statuses/$GITHUB_SHA