import sys, json, yaml
caseFile = sys.argv[1]
scenario = sys.argv[2]
with open(caseFile, 'r') as file:
    prime_service = yaml.safe_load(file)
print(json.dumps(prime_service["scenarios"]["standard"]))
