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

# DB_SCRIPTS_DIR is the folder name inside db_scripts/ in the repo (e.g. mosip_master).
# MOSIP_DB_NAME is the actual Postgres database name to create (e.g. mosip_master02).
# These are decoupled so the repo folder structure never needs to change.
echo "Executing db_script for $MOSIP_DB_NAME (scripts dir: $DB_SCRIPTS_DIR)"

cd "db_scripts/$DB_SCRIPTS_DIR"

bash deploy.sh
