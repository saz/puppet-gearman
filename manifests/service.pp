class gearman::service {
    service { $gearman::params::service_name:
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => false,
        pattern    => 'gearmand',
        require    => Class['gearman::config'],
    }
}
