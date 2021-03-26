md5_hash()
{
  if builtin command -v md5 > /dev/null; then
    echo "$1" | md5
  elif builtin command -v md5sum > /dev/null ; then
    echo "$1" | md5sum | awk '{print $1}'
  fi
}

# Distinct project-name value allows us to simultaneously run 
# several integration test suites on a single runner.
# We'll compose it from uniqueness of path and commit hash together.
DIR_MD5=`echo $PWD | md5_hash`
COMMIT_HASH=`git rev-parse --short HEAD`
PROJECT_NAME="${DIR_MD5}_${COMMIT_HASH}"

COMPOSE_FILENAME=dc.test.yml
docker_compose="docker-compose -f $COMPOSE_FILENAME --project-name $PROJECT_NAME"

# Use modern Docker API, increase build speed ~2 times
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1

$docker_compose build webapp
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then exit $EXIT_CODE; fi

# Run app container in detached mode
$docker_compose up -Vd webapp
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then exit $EXIT_CODE; fi

# Check if record key is set, otherwise do not record the test run
if [ -z "${CYPRESS_RECORD_KEY}" ]; then RECORD_FLAG=""; else RECORD_FLAG="--record" ;fi

# -------------- Runner-in-docker approach
# Collect git commit info (useful for Cypress Dashboard)
export COMMIT_INFO_BRANCH=`git branch --show-current`
export COMMIT_INFO_MESSAGE=`git log -1 --pretty=%B`
export COMMIT_INFO_EMAIL=`git log -1 --pretty=format:'%ae'`
export COMMIT_INFO_AUTHOR=`git log -1 --pretty=format:'%an'`
export COMMIT_INFO_SHA=$GITHUB_SHA
# Run integration tests in the attached mode
# Use runner exit code as docker-compose exit code (which is not automatic)
$docker_compose run --workdir="/e2e" test-runner cypress run --headless $RECORD_FLAG
RUNNER_EXIT_CODE=$?

# -------------------
# Alternative solution: run integration tests outside docker (Apple arm64)
# (not recommended, because it requires docker-compose to bind a port on localhost)
# cd integration-tests
# npm i
# CYPRESS_BASE_URL=http://localhost:8080 npm run test-ci -- $RECORD_FLAG
# RUNNER_EXIT_CODE=$?
# cd ..
# -------------------

# If tests fail, show all related logs
if [ $RUNNER_EXIT_CODE -ne 0 ]; then
  LOG_LINES_LIMIT=200
  printf "\n\n showing last $LOG_LINES_LIMIT lines of logs \n\n\n"
  $docker_compose logs --tail $LOG_LINES_LIMIT webapp; 
fi

# Stop and remove app container even in case of failure (this is not automatic)
# Remove volumes.
# Remove built images, but keep pulled ones
$docker_compose rm -fsv webapp test-runner && $docker_compose down --rmi local -v
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then exit $EXIT_CODE; fi

# Return runner exit code 
exit $RUNNER_EXIT_CODE;
