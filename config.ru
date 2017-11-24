# config.ru

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

run Sidekiq::Web
