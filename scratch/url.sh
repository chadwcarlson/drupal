# # SCENARIO=umami-demo
# # SCENARIO_FILE='.github/tests/data/statuses.yaml'
# TARGET_URL='https://pr-1-djjnuwy-mjmll3fyo4xdq.eu-3.platformsh.site/'

# # DATA=$(python -c '
# # import sys, json, yaml
# # caseFile = sys.argv[2]
# # scenario = sys.argv[1]
# # with open(caseFile) as file:
# #     data = yaml.safe_load(file)
# # print(json.dumps(data["scenarios"][scenario]))
# # ' $SCENARIO $SCENARIO_FILE)

# # echo "$DATA" | jq -r '.[]' | while read -r currentCase; 
# # do .github/tests/verify_status.sh $currentCase $SCENARIO_FILE $TARGET_URL
# # done


# PROJECT_ID=$(python -c '
# import sys
# envURL=sys.argv[1]
# pieces=envURL.split("/")[2].split(".")
# pieces=pieces[len(pieces)-4].split("-")
# print(pieces[len(pieces)-1])
# ' $TARGET_URL)
# echo $PROJECT_ID

# ENV_ID=$(python -c '
# import sys
# envURL=sys.argv[1]
# pieces=envURL.split("/")[2].split(".")
# print("-".join(pieces[len(pieces)-4].split("-")[0:2]))
# ' $TARGET_URL)
# echo $ENV_ID

# PROJECT_REGION=$(python -c '
# import sys
# envURL=sys.argv[1]
# pieces=envURL.split("/")[2].split(".")
# print(pieces[len(pieces)-3])
# ' $TARGET_URL)
# echo $PROJECT_REGION


# echo "'ssh.$PROJECT_REGION.platform.sh'"
# echo "'git.$PROJECT_REGION.platform.sh'"

# if [[ ! -z "${DEPLOY_ENV}" ]]; then
#   echo "VARIABLE is set"
# else
#   echo "VARIABLE is not set"
# fi

# if ! git config remote.platformb.url &> /dev/null
# then
#     echo "Need to set project"
# fi

# VERIFY=$(~/.platformsh/bin/platform auth:info id --no-auto-login)
# echo $VERIFY
# if ! echo $VERIFY &> /dev/null
# then
#     echo "GOTTA LOGIN"
# fi

# cmd=something
REMOVE=starter
SCENARIOS=$(python -c '
import os
import sys
import json
dirs=os.listdir("{}/.github/tests/status/scenarios".format(os.getcwd()))
scenarios=[scenario.split(".")[0] for scenario in dirs]
scenarios.remove(sys.argv[1])
print(json.dumps(scenarios))
' $REMOVE)
# echo "::set-output name=templates::$SCENARIOS"
echo $SCENARIOS