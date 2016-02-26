#!/bin/sh

top=`git rev-parse --show-toplevel`

#check git repo.
if [ ! $? -eq 0 ]
then		
	echo "Invalid a git repository. This should run on the git repository."
	exit;
fi

unstaged=(`git diff --name-only`)
staged=(`git diff --name-only --staged`)
untracked=(`git ls-files --other --exclude-standard $top`)
files="${unstaged[*]} ${staged[*]} ${untracked[*]}"
csRepo="git@github.com:checkstyle/checkstyle.git"
csHome="$JCHECK_HOME/checkstyle"
csJar='checkstyle.jar'
curDir=`PWD`
result="Aborted."

echo $files

#check whether mvn is installed.
if ! type mvn > /dev/null; 
then
	echo "Install mvn first. URL : http://maven.apache.org/download.cgi"; 
	exit
fi

#check whether JCHECK_HOME is set.
if [ -z "$JCHECK_HOME" ] 
then
	echo "Please set a variable - JCHECK_HOME. ex) export JCHECK_HOME=/path_to_jcheck_repo"
	exit
fi

config_name="$JCHECK_HOME/checkstyle.xml"

while [[ $# > 1 ]]
do
key="$1"

case $key in
    -c|--config)
    config_name="$2"
    shift
    ;;
esac
shift
done

if [ ! -f $config_name ] 
then
	echo "Invalid rules. : $config_name"
	exit;
fi

if [ ${#files[@]} -eq 0 ]
then	
	echo "No files to check the code style."
	exit;
fi

echo "executed at $curDir"
echo "JCHECK_HOME : $JCHECK_HOME"
echo "csHome : $csHome"
echo "rules : $config_name"

cd $JCHECK_HOME
if [ ! -f $csJar ] 
then
	echo "Not found checkstyle.jar. Let's making it."
	#Clone checkstyle repo
	echo "Clonning the checkstyle repo."
	git clone $csRepo checkstyle
	cd checkstyle
	#build jar
	echo "Build the checkstyle jar."
	mvn clean package -Passembly -q
	echo "Building the checkstyle jar is DONE!"
	cp target/*-all.jar $JCHECK_HOME/$csJar
	echo "Copy the jar is DONE!"
fi

cd $JCHECK_HOME

if [ -f $csJar ] 
then
	for f in $files
	do
		echo "file : $f"
		echo "path : $top/$f"
		java -jar checkstyle.jar -c $config_name $top/$f
	done
	
	result="Checking is DONE!"
fi

if [ -d $csHome ] 
then
	echo "remove the checkstyle repo."
	rm -rf $csHome
fi

cd $curDir
echo $result
