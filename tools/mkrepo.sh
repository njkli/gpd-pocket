#!/bin/bash
repodir=$PWD/repo
reponame=gpd-pocket
declare -a ext="db files"

repo-add $repodir/$reponame.db.tar.gz $repodir/*.pkg.tar.xz

for i in ${ext[@]}
do
    rm $repodir/$reponame.$i
    mv $repodir/$reponame.$i.tar.gz $repodir/$reponame.$i
done
