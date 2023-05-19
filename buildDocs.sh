#!/bin/bash

# Check if the current folder has a clean git status
status=$(git status --short)

# If the status is not clean, abort with an error message
if [[ $status != "" ]]; then
  echo "The current folder has uncommitted changes. Aborting."
  exit 1
fi

# Global variables
project_name="MakeItSo"
project_path="code/frontend/$project_name"
scheme_name="MakeItSo"
hosting_base_path="MakeItSo/"

# Create a temporary directory
tmp_dir=$(mktemp -d)

# Create a folder inside the temporary directory
build_folder=$(mktemp -d "$tmp_dir/$project_name")
docsData_folder=$(mktemp -d "$build_folder/docsData")

# Print the path to the new folder
echo "$new_folder"

echo "Building DocC documentation for $project_name..."

echo "${project_path}/${project_name}.xcodeproj"
echo "$docsData_folder"
echo "$scheme_name"

xcodebuild -project ${project_path}/${project_name}.xcodeproj \
  -derivedDataPath $docsData_folder \
  -scheme $scheme_name \
  -destination 'platform=iOS Simulator,name=iPhone 14 Pro' \
  -parallelizeTargets docbuild

echo "Copying DocC archives to $docsData_folder..."
docArchives_folder=$(mktemp -d "$build_folder/docArchives")
cp -R `find $docsData_folder -type d -name "*.doccarchive"` $docArchives_folder


docs_folder=$(mktemp -d "$build_folder/docs")
for ARCHIVE in $docArchives_folder/$project_name.doccarchive; do
    cmd() {
        echo "$ARCHIVE" | awk -F'.' '{print $1}' | awk -F'/' '{print tolower($2)}'
    }
    ARCHIVE_NAME="$(cmd)"
    echo "Processing Archive: $ARCHIVE"
    $(xcrun --find docc) process-archive transform-for-static-hosting "$ARCHIVE" \
      --hosting-base-path $hosting_base_path --output-path $docs_folder
done

git fetch

# git stash push -u  -- docs doc_archives

git checkout tutorial/pages

# rm -rf docs doc_archives

# git stash apply

cp -R $docs_folder .
git add docs
git commit -m "📝 Updated DocC documentation"

# # git push --set-upstream origin tutorial/pages
