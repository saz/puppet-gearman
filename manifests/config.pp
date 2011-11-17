class gearman::config {
    if $gearman::params::_maxfiles > 1024 {
        limits::limits { 'gearman_nofiles':
            ensure     => present,
            user       => 'gearman',
            limit_type => 'nofile',
            hard       => $gearman::params::maxfiles,
            soft       => $gearman::params::maxfiles,
        }
    }

    file { $gearman::params::config_file:
        ensure  => present,
        owner   => root,
        group   => root,
        content => template("${module_name}/default.erb"),
        require => Class['gearman::install'],
        notify  => Class['gearman::service'],
    }
}
