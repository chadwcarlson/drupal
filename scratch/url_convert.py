import sys,yaml
import requests
import subprocess
case = sys.argv[1]
caseFile = sys.argv[2]
base_url = sys.argv[3]
if base_url[len(base_url)-1] == "/":
    base_url = base_url[:len(base_url)-1]

test_result='pass'

with open(caseFile) as file:
    data = yaml.safe_load(file)
    current_case = data['cases'][case]
    print("\nTesting: {0}".format(current_case['name']))
    for endpoint in current_case['tests']:
        expected_status=current_case['tests'][endpoint]
        test_url="{0}{1}".format(base_url, endpoint)
        response = requests.get(test_url)
        if response.status_code == expected_status:
            print("     " + u'\u2714' + " PASS - [{0}] Path: {1}".format(expected_status, endpoint))
        else:
            print("     " + u'\u2718' + " FAIL - Path: {0}".format(endpoint))
            print("            - Actual: {0}".format(response.status_code))
            print("            - Expected: {0}".format(expected_status))
            test_result='fail'
with open("status_results.txt", "w") as file1:
    # Writing data to a file
    file1.write(test_result)

