#!/usr/bin/env bash

# From https://github.com/marakim/git-clone-for-worktree

for arg
do
  if [ "$arg" = --single-branch ]
  then
    SingleBranch=1
  elif [ -z ${Repository+x} ]
  then
    Repository="$arg"
  elif [ -z ${Directory+x} ]
  then
    Directory="$arg"
  else
    echo 'Usage: [--single-branch] <repository> [<directory>]'
    exit 1
  fi
done

if [ -z ${Repository+x} ]
then
  echo 'Usage: [--single-branch] <repository> [<directory>]'
  exit 1
fi

if [ -z ${Directory+x} ]
then
  Directory="$(basename "${Repository}" .git)"
fi


DirectoryExists="$(test -d "${Directory}"; echo $?)"

if [ "$SingleBranch" = 1 ]
then
  git clone --single-branch --bare "${Repository}" "${Directory}/.bare"
else
  git clone --bare "${Repository}" "${Directory}/.bare"
fi


if [ $? -ne 0 ]
then
  if [ ${DirectoryExists} -ne 0 ]
  then
    rmdir "${Directory}"
  fi
  exit 1
fi

echo "gitdir: ./.bare" > "${Directory}/.git"

pushd "${Directory}" >/dev/null

DefaultBranch="$(git rev-parse --abbrev-ref HEAD)"

if [ "$SingleBranch" = 1 ]
then
  git config --add remote.origin.fetch "+refs/heads/${DefaultBranch}:refs/remotes/origin/${DefaultBranch}"
else
  git config --add remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
fi

git worktree add "${DefaultBranch}"

git fetch origin

popd >/dev/null
