define apache::config($ensure = 'present', $source = '', $content = '') {
 validate_string($source, $content)
  if ($ensure != 'present' and $ensure != 'absent') {
    fail("Apache::Config[$name] ensure should be one of present/absent")
  }

  if (!$content and !$source and $ensure != 'absent') {
    fail("Apache::Config[$name] either source or content must be present")
  }
  elsif ($content and $source) {
    fail("Apache::Config[$name] cannot specify both source and content")
  }

  $conf_path   = "/etc/apache2/conf.d/${name}.conf"

  File {
    notify  => Service['apache2'],
    ensure  => $ensure,
    require => Package['apache2'],
  }

  if ($content) {
    file { $conf_path:
      content => $content,
    }
  }
  elsif ($ensure != 'absent') {
    file { $conf_path:
      source => $source,
    }
  }
  else {
    file { $conf_path:
      ensure => 'absent',
    }
  }
}