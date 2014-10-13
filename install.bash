#!/usr/bin/env bash
#
# Installs configuration files to User's home directory
# ----------------------------------------------------------------------
# TODO Add Dry Run Default
# ----------------------------------------------------------------------


force_opt=${1:-''}
prefix=${2:-"$HOME"}
srcdir="hellabyte_dotfiles"
tardir="${prefix}"
bakdir="${tardir}/.local/var/configuration-backups"
now=$(date +"%Y.%m.%d-%H.%M")
spcdir="${bakdir}/${now}"
procs=4 # Assume 4 threads for xargs

if ! [[ -d $spcdir ]]; then
  echo "Making Backup directory -- $spcdir" 
  echo "Will be automatically deleted if no backups are made"
  mkdir -p $spcdir
fi

for d in $(find hellabyte_dotfiles -type d -print); do
  relative_dname="${d#/*}"
  target_dname="${tardir}/${relative_dname}"
  if ! [[ -d $target_dname ]]; then
    mkdir -pv $target_dname
  fi
done | xargs -P $procs
for f in $(find hellabyte_dotfiles -type f -print); do 
  relative_fname="${f#/*}"
  target_fname="${tardir}/${relative_fname}"
  if ! [[ -e $target_fname ]]; then
    echo "$target_fname not found, freshly installing"
  else
    diff_res=$(diff -q $f $target_fname)
    if ! [[ -z $diff_res ]]; then
      echo "$target_fname found, backing up then installing"
      mv -v $target_fname $spcdir
    fi
  fi
  cp -v $f $target_fname
done | xargs -P $procs

# Check to see if backup was actually done
readarray backup_check < <(ls -A1 $spcdir)
nBack=${#backup_check[@]}
echo "Install complete."
if [[ $nBack -eq 0 ]]; then
  rm -r $spcdir
  echo "No backups were made."
else
  echo "${nBack} backups were put in the following directory: $spcdir"
fi
