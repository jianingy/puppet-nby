class nby(
  $fullname,
  $email,
) {

  include 'concat::setup'

  file {"$home/.gitconfig":
    ensure   => present,
    mode     => '0644',
    content  => template('nby/gitconfig.erb'),
  }

  file {"$home/.tmux.conf":
    ensure   => present,
    mode     => '0644',
    source   => 'puppet:///modules/nby/tmux.conf',
  }

    # setup ssh public key
  file {"$home/.ssh":
    ensure   => directory,
    mode     => '0755',
    force    => true,
  } ->
  concat {'authorized_keys':
    path     => "$home/.ssh/authorized_keys",
    mode     => '0644',
  } ->
  file {"$home/.ssh/authorized_keys2":
    ensure   => link,
    target   => 'authorized_keys',
    mode     => '0644',
  }

}
