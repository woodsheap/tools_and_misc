#!/bin/bash
# SPDX-FileCopyrightText: 2023 Brian Woods
# SPDX-License-Identifier: GPL-2.0-or-later

# settings
CMD=""
TIME_BASE=10		# always wait this time
TIME_RND=0		# above plus 0-120

# pathes
LOCK="queue.lock"
QUEUE="queue.file"
WORKER_PID="queue_worker.pid"

# references for why I went with sed, that and ease use
# https://www.baeldung.com/linux/remove-first-line-text-file

queue_shift ()
{
	queue_item=""
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

	if [ -f "$QUEUE" ] ; then
		local line="$(head -n 1 $QUEUE)"
		sed -i '1d' "$QUEUE"

		#delete if empty
		if [ ! -s "$QUEUE" ] ; then
			rm "$QUEUE"
		fi
	fi

	# release lock
	flock -u "$lock_fd"
	exec {lock_fd}>&-

	queue_item="$line"
}

queue_work ()
{
	local rv=1
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

	# we have work
	if [ -f "$QUEUE" ] ; then
		rv=0
	fi

	# release lock
	flock -u "$lock_fd"
	exec {lock_fd}>&-

	return $rv
}

sleep_pause ()
{
	if [ "$TIME_RND" = "0" ] ; then
		local sleep_period="$TIME_BASE"
	else
		local sleep_period=$(( RANDOM % TIME_RND + TIME_BASE ))
	fi
	sleep "$sleep_period"
}

# FIRST thing is to create PID file
if [ ! -f "$WORKER_PID" ] ; then
	echo "$$" > "$WORKER_PID"
else
	echo "worker already running, exiting"
	exit 1
fi

# XXX
# add checks for PID file every .1 seconds so sleep for x2 that just to
# make sure
sleep .2

while queue_work ; do
	queue_shift
	if [ ! -z "$queue_item" ] ; then
		if [ ! -z "$CMD" ] ; then
			$CMD $queue_item
		else
			eval "$queue_item"
		fi
	fi
	sleep_pause
done

# remove PID file right before exiting
rm -f "$WORKER_PID"
