#!/bin/bash

if [ -z "$KRSYNC_STARTED" ]; then
	export KRSYNC_STARTED=true
	exec rsync --blocking-io --rsh "$0" $@
fi

# Running as --rsh
namespace=''
mypod=$1
shift

# If user uses pod@namespace, rsync passes args as: {us} -l pod namespace ...
if [ "X$mypod" = "X-l" ]; then
	mypod=$1
	shift
	namespace="-n $1"
	shift
fi

exec kubectl $namespace exec -i $mypod -- "$@"
