# puppet-gearman

[![Build Status](https://secure.travis-ci.org/saz/puppet-gearman.png)](http://travis-ci.org/saz/puppet-gearman)

Manage gearman configuration via Puppet

## Usage

```
    include gearman
```

### Higher file descriptor limit

**Requires saz-limits module from forge.puppetlabs.com**

```
    $gearman_maxfiles = 16384
    include gearman
```

### Other values

* $gearman_job_retries: default 0
* $gearman_port: default 4730
* $gearman_listen: default 0.0.0.0
* $gearman_threads: default 4
