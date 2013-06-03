class nby::emacs {
  # pull emacs configuration from github
  file {"$home/.emacs.d":
    ensure   => directory,
    mode     => '0755',
    force    => true,
  } ->
  nby::git::update {'emacs':
    repo     => 'git@github.com:jianingy/emacs-ysl',
    branch   => 'master',
    place    => "$home/.emacs.d",
  }
}
