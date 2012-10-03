class gearman::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'gearman-job-server'
      $config_file = '/etc/default/gearman-job-server'
      $config_file_template = "${::osfamily}/default.erb"
      $service_name = 'gearman-job-server'
      $maxfiles = 1024
      $user = 'gearman'
    }
    default: {
      case $::operatingsystem {
        default: {
          fail("Unsupported platform: ${::osfamily}/${::operatingsystem}")
        }
      }
    }
  }

  $backlog = 32
  $job_retries = 0
  $port = 4730
  $listen = '0.0.0.0'
  $threads = 4
  $worker_wakeup = 0
}
