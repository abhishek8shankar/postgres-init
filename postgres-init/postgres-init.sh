#!/bin/bash

set -e

echo "Cloning $GIT_BRANCH of repo $GIT_REPO_URL for $MOSIP_DB_NAME db_scripts"

git_repo_name="$(basename "$GIT_REPO_URL" .git)"

# Use sparse checkout configured before clone so only db_scripts/ is fetched,
# saving bandwidth instead of cloning the full repo tree first.
git clone --depth 1 --branch "$GIT_BRANCH" --no-checkout --filter=blob:none "$GIT_REPO_URL"

echo "Successfully cloned the repository"

cd "$git_repo_name"

git sparse-checkout init --cone
git sparse-checkout set db_scripts
git checkout

echo "Extracted only db_scripts"

echo "Executing db_script for $MOSIP_DB_NAME"

cd "db_scripts/$MOSIP_DB_NAME"

bash deploy.sh
