class gearman::config {
    file { $gearman::param::default_config_file:
        ensure  => file,
        owner   => root,
        group   => root,
        content => template("${module_name}/default.erb"),
        require => Class['gearman::install'],
        notify  => Class['gearman::service'],
    }
}
