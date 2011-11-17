class gearman::config {
    if $gearman_maxfiles != undef {
        if $gearman_maxfiles > 1024 {
            limits::limits { 'gearman_nofiles':
                ensure     => present,
                user       => 'gearman',
                limit_type => 'nofile',
                hard       => $gearman_maxfiles,
                soft       => $gearman_maxfiles,
                notify     => Class['gearman::service'],
            }
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
