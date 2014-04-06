environment ENV['RAILS_ENV']

threads 2,8
workers 2

pidfile "tmp/pids/puma.pid"
state_path "tmp/puma.state"
stdout_redirect 'log/puma_stdout.log','log/puma_stderr.log'
bind 'unix://tmp/sockets/puma.sock'

preload_app!

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

