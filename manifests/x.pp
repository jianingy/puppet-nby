class nby::x {
  file {"$home/.xinitrc":
    ensure   => present,
    mode     => '0644',
    source   => 'puppet:///modules/nby/xinitrc',
  } ->
  file {"$home/.xsession":
    ensure   => link,
    target   => '.xinitrc',
    mode     => '0644',
  }

  file {"$home/.Xdefaults":
    ensure   => present,
    mode     => '0644',
    source   => 'puppet:///modules/nby/Xdefaults',
  }

  file {"$home/.compton.conf":
    ensure   => present,
    mode     => '0644',
    source   => 'puppet:///modules/nby/compton.conf',
  }

  # pull emacs configuration from github
  file {"$home/.xmonad":
    ensure   => directory,
    mode     => '0755',
    force    => true,
  } ->
  file {"$home/.xmonad/xmonad.hs":
    ensure   => present,
    mode     => '0644',
    source   => 'puppet:///modules/nby/xmonad.hs',
  }
}
