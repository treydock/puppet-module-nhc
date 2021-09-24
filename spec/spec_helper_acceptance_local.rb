dir = File.expand_path(File.dirname(__FILE__))
Dir["#{dir}/acceptance/shared_examples/**/*.rb"].sort.each { |f| require f }

def sysconf_path
  if fact('os.family') == 'Debian'
    '/etc/default/nhc'
  else
    '/etc/sysconfig/nhc'
  end
end
