# frozen_string_literal: true

dir = __dir__
Dir["#{dir}/acceptance/shared_examples/**/*.rb"].sort.each { |f| require f }

def sysconf_path
  if fact('os.family') == 'Debian'
    '/etc/default/nhc'
  else
    '/etc/sysconfig/nhc'
  end
end
