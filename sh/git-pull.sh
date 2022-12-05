#!/bin/sh

# walk throught all sub folders to pull codes.
# add excluded folders to var EXCLUDES

EXCLUDES=""

for d in `ls`; do
  filtered=0

  [ ! -d $d ] && continue

  for e in $EXCLUDES; do
	if [ "$d" = "$e" ]; then
      filtered=1
	  break
	fi
  done

  [ $filtered = 1 ] && break

  pushd $d
  git pull
  popd >/dev/null
done
