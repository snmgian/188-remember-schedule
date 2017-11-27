# sidekiq -r ./hello-scheduler-3.rb

require 'sidekiq-scheduler'

class HelloWorld
  include Sidekiq::Worker

  def perform(*args)
    puts 'Hello world' + " #{args.inspect}"
  end
end

require 'pp'

all_schedules = Sidekiq.get_all_schedules

pp all_schedules

Sidekiq.schedule = all_schedules
