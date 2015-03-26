#!/bin/bash
set -e

echo =============================================================================
# go to project dir
SCRIPT_DIR=$(dirname $0)
cd $SCRIPT_DIR/../..

./node_modules/.bin/webdriver-manager update

function killServer () {
  kill $serverPid
}

./node_modules/.bin/gulp serve.js.dart2js&
serverPid=$!

trap killServer EXIT

# wait for server to come up!
sleep 10

echo "Starting Selenium Standalone Server"
echo "Java version"
java -version 

java -jar node_modules/protractor/selenium/selenium-server-standalone-2.45.0.jar -Dwebdriver.chrome.driver=node_modules/protractor/selenium/chromedriver &

# Wait for selenium standalone to come up
sleep 5

./node_modules/.bin/protractor protractor-dart2js.conf.js --browsers=ChromeDownloaded
