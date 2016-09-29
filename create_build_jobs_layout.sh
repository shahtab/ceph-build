#! /usr/bin/env bash

set -e

echo "Enter project name"
read PROJECT
echo "Enter github name as in github.com/ceph/<github_name>"
read GITHUB

echo "You entered:"
echo "PROJECT=$PROJECT"
echo "GITHUB=$GITHUB"

if test -e ${PROJECT} -o -e ${PROJECT}-setup -o -e ${PROJECT}-build; then
	echo "The current directory contains files/directories that conflict with the layout, please remove all of these:"
	echo ${PROJECT}{,-setup,-build}
	exit 1
fi

## Create the initial directory structure
cp -a template ${PROJECT}
cp -a template-setup ${PROJECT}-setup
cp -a template-build ${PROJECT}-build

## Fix up the filenames
mv ${PROJECT}/config/definitions/template.yml ${PROJECT}/config/definitions/${PROJECT}.yml
mv ${PROJECT}-setup/config/definitions/template-setup.yml ${PROJECT}-setup/config/definitions/${PROJECT}-setup.yml
mv ${PROJECT}-build/config/definitions/template-build.yml ${PROJECT}-build/config/definitions/${PROJECT}-build.yml

find ${PROJECT}{,-setup,-build} -type f -exec sed -i -e "s/PROJECT/$PROJECT/g" {} \;
find ${PROJECT}{,-setup,-build} -type f -exec sed -i -e "s/GITHUB/$GITHUB/g" {} \;

echo "The following jobs were created:" ${PROJECT}{,-setup,-build}
echo "Please follow all the TODO markers to complete the creation of the build jobs"
exit 0
