# sidekiq -r ./hello-scheduler-4.rb

require 'sidekiq-scheduler'

class HelloWorld
  include Sidekiq::Worker

  def perform(*args)
    puts 'Hello world' + " #{args.inspect}"
  end
end

require 'pp'
require 'yaml'

DUMP_FILE = 'schedule.dump.yml'

Sidekiq.configure_server do |config|
  config.on(:startup) do
    next if !File.exist?(DUMP_FILE)

    schedule = YAML.load_file(DUMP_FILE)

    Sidekiq.schedule = schedule
    Sidekiq::Scheduler.reload_schedule!
  end

  config.on(:shutdown) do
    schedule = Sidekiq.get_all_schedules
    puts schedule.to_yaml

    File.write(DUMP_FILE, YAML.dump(schedule))
  end
end
