# puppet-gearman

[![Build Status](https://secure.travis-ci.org/saz/puppet-gearman.png)](http://travis-ci.org/saz/puppet-gearman)

Manage gearman via Puppet

## How to use

```ruby
    class { 'gearman': }
```

### Higher file descriptor limit

**Requires saz-limits module from forge.puppetlabs.com**

```ruby
    class { 'gearman':
      maxfiles => 16384,
    }
```

### RedHat / CentOS package support

Gearman packages for the RedHat OS family are available in the EPEL repository. You need the [puppet-epel](https://github.com/stahnma/puppet-module-epel) module available for RHEL / CentOS support.

### All class parameters

* $ensure = 'present'
* $backlog =
* $job_retries =
* $port = 4730
* $listen = '0.0.0.0'
* $threads = 4
* $maxfiles = 1024  # on Debian based systems
* $worker_wakeup = 0
* $log_file = undef
* $verbose = undef  # e.g. 'vv'
* $queue_type = undef
* $queue_params = undef
* $disable_limits_module = false    # true will disable saz-limits usage
* $config_file = '/etc/default/gearman-job-server'  # on Debian based systems
* $config_file_template = 'Debian/default.erb'  # on Debian based systems
* $autoupgrade = false  # true: package ensure will be set to 'latest'
* $package_name = 'gearman-job-server'  # on Debian based systems
* $service_ensure = 'running'
* $service_name = 'gearman-job-server'  # on Debian based systems
* $service_enable = true
* $service_hasstatus = false
* $service_hasrestart = true
