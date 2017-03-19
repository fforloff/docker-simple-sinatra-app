# Set the working application directory
working_directory "/app"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "/tmp/unicorn.pid"

# Path to logs
stderr_path "/dev/stderr"
stdout_path "/dev/stdout"

# Unicorn socket
# listen "/tmp/unicorn.[app name].sock"
listen "/tmp/unicorn.sock"

# Number of processes
# worker_processes 4
worker_processes 2

# Time-out
timeout 30
