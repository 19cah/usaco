#!/usr/bin/env bash

if ([ "$1" != "major" ] && [ "$1" != "minor" ] && [ "$1" != "patch" ])
  then
    echo "please specify one of (major, minor, patch)"
    exit
fi

git checkout master
git add .
git commit --allow-empty-message -m ''

npm install
npm version $1

# Getting package version
PACKAGE_VERSION=$(cat package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g')

echo $PACKAGE_VERSION

# Add all
git add .
git commit -m "$PACKAGE_VERSION published"

# Publish package
npm publish

# Push commits
git push origin master

# Tag version
git tag -a $PACKAGE_VERSION -m  "Welcome to $PACKAGE_VERSION version"
git push origin --tags
