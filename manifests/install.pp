class gearman::install {
    package { $gearman::params::package_name:
        ensure => present,
    }
}
