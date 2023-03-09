#!/bin/bash

rm -rf docsData

echo "Building DocC documentation for MakeItSo..."

xcodebuild -project code/frontend/MakeItSo/MakeItSo.xcodeproj -derivedDataPath docsData -scheme MakeItSo -destination 'platform=iOS Simulator,name=iPhone 14 Pro' -parallelizeTargets docbuild

echo "Copying DocC archives to doc_archives..."

mkdir doc_archives

cp -R `find docsData -type d -name "*.doccarchive"` doc_archives

mkdir docs

for ARCHIVE in doc_archives/*.doccarchive; do
    cmd() {
        echo "$ARCHIVE" | awk -F'.' '{print $1}' | awk -F'/' '{print tolower($2)}'
    }
    ARCHIVE_NAME="$(cmd)"
    echo "Processing Archive: $ARCHIVE"
    $(xcrun --find docc) process-archive transform-for-static-hosting "$ARCHIVE" --hosting-base-path MakeItSo/ --output-path docs
done

git fetch

git stash push -u  -- docs doc_archives

git checkout tutorial/pages

rm -rf docs doc_archives

git stash apply

git add docs doc_archives

git commit -m "📝 Updated DocC documentation"

# git push --set-upstream origin tutorial/pages