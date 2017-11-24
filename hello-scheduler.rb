# sidekiq -r ./hello-scheduler.rb

require 'sidekiq-scheduler'

class HelloWorld
  include Sidekiq::Worker

  def perform
    puts 'Hello world'
  end
end

require 'pp'
require 'yaml'

DUMP_FILE = 'schedule.dump.yml'

def get_schedule
  schedule   = Sidekiq.get_schedule
  next_times = Redis.current.hgetall(Sidekiq::Scheduler.next_times_key)

  next_times.each do |job_key, first_at|
    job = schedule[job_key]

    if job
      add_first_at(job, first_at)
    end
  end

  schedule
end

def add_first_at(job_schedule, first_at)
#cron every at in interval
  repeat_job_types = %w(cron every interval)

  first_at_option = { 'first_at' => first_at }

  job_schedule.each do |k, v|
    if repeat_job_types.include?(k)
      if v.is_a?(Array)
        v[1] = first_at_option
      else
        job_schedule[k] = [v, first_at_option]
      end
    end
  end
end

Sidekiq.configure_server do |config|
  config.on(:startup) do
    next if !File.exist?(DUMP_FILE)

    schedule = YAML.load_file(DUMP_FILE)

    Sidekiq.schedule = schedule
    Sidekiq::Scheduler.reload_schedule!
  end

  config.on(:shutdown) do
    schedule = get_schedule
    puts schedule.to_yaml

    #File.write(DUMP_FILE, YAML.dump(schedule))
  end
end
