class nby::x {
  file {"$home/.xinitrc":
    ensure   => present,
    mode     => '0644',
    source   => 'puppet:///modules/nby/xinitrc',
  }

  file {"$home/.Xdefaults":
    ensure   => present,
    mode     => '0644',
    source   => 'puppet:///modules/nby/Xdefaults',
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
