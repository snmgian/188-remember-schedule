WARN about Sidekiq::Scheduler.next_times_key


Remember dynamic schedule after restarting sidekiq-scheduler

A dynamic schedule is the one that, so the initial configuration gets old.

After a restart, sidekiq-scheduler reads the config being passed in, so prior dynamic modifications are lost.

There are two ways to overcome this

Set the schedule base on what is present in redis

Store the schedule in a file, and load it on startup


## Set the schedule base on what is present in redis


```ruby
# initializers/sidekiq-scheduler.rb

require 'sidekiq-scheduler'

Sidekiq.schedule = Sidekiq.get_all_schedules
```

Please not that if `get_all_schedules` returns an empty hash, you don't know whether the schedules were removed or this is the first startup.

This can be a problem in the case you want an initial/bootstrap schedule. If you don't want that and you'll be setup all of your schedules in a dynamic way then that approach will work ok.

This approach doesn't remember the next time a job will be enqueued

## Store the schedule in a file, and load it on startup

```ruby
# initializers/sidekiq-scheduler.rb

```



******************
Within `Sidekiq.schedule = Sidekiq.get_all_schedules` approach, if `get_all_schedules` returns an empty hash, you don't know whether the schedules were removed or this is the first startup.

