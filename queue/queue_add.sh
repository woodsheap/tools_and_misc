#!/bin/bash
# SPDX-FileCopyrightText: 2023 Brian Woods
# SPDX-License-Identifier: GPL-2.0-or-later

# paths
LOCK="queue.lock"
QUEUE="queue.file"
WORKER="./queue_worker.sh"
WORKER_PID="queue_worker.pid"
WORKER_LOG="queue_worker.log"

queue_push ()
{
	local lock_fd="3"
	# aquire lock
	if ! exec {lock_fd}>"$LOCK" ; then
		echo "Can't get lockfile fd"
		return
	fi

	if ! flock -w 10 "$lock_fd" ; then
		echo "couldn't get lock"
		return
	fi

	# actually write it out
	echo "$@" >> "$QUEUE"

	# release lock
	flock -u "$lock_fd"
	exec {lock_fd}>&-
}

spawn_worker ()
{
	nohup "$WORKER" >> "$WORKER_LOG" &

	# 5 seconds of waiting
	local max=50
	local tries=0
	while [ "$tries" -lt "$max" ]  ; do
		sleep .1
		tries=$(( tries + 1 ))

		if [ -f "$WORKER_PID" ] ; then
			break
		fi
	done
	if [ "$tries" = "$max" ] ; then
		echo "warning waiting period without worker PID created"
	fi
}

queue_push $@

# need to do some locking if we want this to be actually safe
# 1. get lock, 2. spin off worker, 3. wait until pid, 4. release lock
if [ ! -f "$WORKER_PID" ] ; then
	spawn_worker
fi
