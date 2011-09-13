class gearman::config {
    file { $gearman::params::default_config_file:
        ensure  => present,
        owner   => root,
        group   => root,
        content => template("${module_name}/default.erb"),
        require => Class['gearman::install'],
        notify  => Class['gearman::service'],
    }
}
