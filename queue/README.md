# Queue scripts

Basically these scripts are used for throwing commands in a queue and
then running them sequentially with a configurable about of time between
them.
This allows for just throwing things in the queue and forgetting about
them without having to manually run commands one after the other.

## Usage
Configuring the paths is highly suggested.  You can have everything
other than the queue\_add.sh script in a queue directory.
There's also the `CMD` variable useful if you're just running one
command with differing or even the same options.
The `TIME_BASE` and `TIME_RND` are useful to spacing the queue tasks
out if need be.

## Example
	./queue_add.sh 'echo 1 >> log.txt'
	./queue_add.sh 'echo 2 >> log.txt'
	./queue_add.sh 'echo 3 >> log.txt'
	./queue_add.sh 'echo 4 >> log.txt'
	./queue_add.sh 'echo 5 >> log.txt'
	sleep 1         # give it enough time to run the first job
	tail -f log.txt # see the output
