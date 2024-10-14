# frozen_string_literal: true

RSpec.configure do |c|
  c.before :suite do
    on hosts, 'mkdir -p /etc/cron.hourly'
  end
end
